# A set of formatting functions, include this in your model as necessary.
module Formatters
  # Set/update the created_by, updated_by values
    def set_modifiers current_user
      self[:created_by] = current_user.first_name||' '||current_user.last_name if self[:id].nil?
      self[:updated_by] = current_user.first_name||' '||current_user.last_name
    end
 # Used to check if the params passed in for update contain real changes
 # Remember to define formatted_fields private function in each of your models
 # for and fields that get special formatting performed prior to save
 # Returns boolean
 def contains_changes? params_hash
   changed = false
   special_fields = formatted_fields
   params_hash.each do |k, v|
     unless k == 'lock_version'
       if special_fields[k.to_sym]
         v.strip! unless special_fields[k.to_sym].index('strip').blank?
         v.gsub!(' ', '') unless special_fields[k.to_sym].index('strip_all_whitespace').blank?
         v.upcase! unless special_fields[k.to_sym].index('upcase').blank?
         v.downcase! unless special_fields[k.to_sym].index('downcase').blank?
         #titleize doesnt work on string.
         v = v.split(" ").map{|word| word.capitalize}.join(" ") unless special_fields[k.to_sym].index('titleize').nil?
       end
       if self.respond_to?(k)
         # TODO likely will need to add more datatypes
         # also need to do some duck type checking
         if self.type_for_attribute(k).type == :string
           if self[k].blank?
             changed = true unless self[k].to_s == v
           else
             changed = true unless self[k] == v
           end
         elsif self.type_for_attribute(k).type == :text
           if self[k].blank?
             changed = true unless self[k].to_s == v
           else
             changed = true unless self[k] == v
           end
         elsif self.type_for_attribute(k).type == :boolean
           truthy = [1, "1", true, "true", "True", "TRUE"]
           bool = truthy.index(v).nil? ? false : true
           changed = true unless self[k] == bool
         elsif self.type_for_attribute(k).type == :integer
           if v.respond_to?(:to_i)
             changed = true unless self[k] == v.to_i
           elsif v.class == Array && self[k].class == Array  # it is array of integers
             # assumed that the sequence of integers in the array is not important
             k_tmp = self[k].dup
             k_tmp.delete(nil)  # remove nil in array before sorting
             v_tmp = v.dup
             v_tmp.delete(nil)
             changed = true unless k_tmp.sort == v_tmp.map(&:to_i).sort
           else
             # Not sure what client is trying here but let model handle error!
             changed = true
           end
         elsif self.type_for_attribute(k).type == :decimal
           if v.respond_to?(:to_d)
             changed = true unless self[k] == v.to_d
           else
             # Not sure what client is trying here but let model handle error!
             changed = true
           end
         elsif self.type_for_attribute(k).type == :date
           if self[k].blank?
             changed = true unless self[k].to_s == v
           else
             changed = true unless self[k].to_s(:medium) == v
           end
         elsif self.type_for_attribute(k).type == :json
           eval_error = ""
           begin
             eval(JSON.parse(v.to_json).to_s)
           rescue Exception => eval_error
           end
           if eval_error.blank?
             if self.class.name.downcase == "notification" # only for the notification class
               changed = true unless (self[k].to_s == eval(JSON.parse(v.to_json)).with_indifferent_access.to_s)
             else # original logic
               changed = true unless self[k] == eval(JSON.parse(v.to_json).to_s)
             end
           else
             changed = true
             self.errors[k] << eval_error.message
           end
         end
         break if changed
       end
     end
   end
   changed
 end

 private
 # Perform leading and trailing whitespace strip on specified fields
 def strip_whitespace fields_array
   fields_array.each do |f|
     unless self[f].nil?
       if self[f].acts_like?(:string)
         self[f].strip!
         self[f] = nil if self[f].length == 0
       end
     end
   end
 end

 # Remove all whitespaces strip on specified fields
 def strip_all_whitespace fields_array
   fields_array.each do |f|
     unless self[f].nil?
       if self[f].acts_like?(:string)
         self[f].gsub!(' ', '')
         self[f] = nil if self[f].length == 0
       end
     end
   end
 end

 # Convert to uppercase on specified fields
 def transform_uppercase fields_array
   fields_array.each do |f|
     unless self[f].blank?
       self[f].upcase! if self[f].acts_like?(:string)
     end
   end
 end

 # Convert to lowercase on specified fields
 def transform_downcase fields_array
   fields_array.each do |f|
     unless self[f].blank?
       self[f].downcase! if self[f].acts_like?(:string)
     end
   end
 end

 # Convert the first letter of each word to uppercase on specified fields
 def transform_titleize fields_array
   fields_array.each do |f|
     unless self[f].blank?
       self[f] = self[f].split(" ").map{|word| word.capitalize}.join(" ") if self[f].acts_like?(:string)
     end
   end

 end

 # Make sure local timestamp fields are in correct format %Y-%m-%d %H:%M:%S %Z
 # the only formatted this may add is seconds for time and replacing / to - symbol in the date part
 # its important for each model to validate the presence of these local timestamp fields
 # as this function will set the field to nil if it is not in the valid format
 def standardize_local_timestamps fields_array
   fields_array.each do |f|
     unless self[f].blank?
       parts = self[f].strip().split(" ")
       # must have date, time, and zone component
       if parts.length != 3
         self[f] = nil
         break
       end

       # check/set date component to use "-"
       date_part = parts[0].include?("/") ? parts[0].gsub(/\//, "-") : parts[0]
       if date_part.length != 10 || date_part.scan(/\-/).length != 2
         self[f] = nil
         break
       end

       # year must come first YYYY-MM-DD any other order and we could get it wrong
       if date_part.split("-")[0].length != 4
         self[f] = nil
         break
       end

       # set 00 for seconds if not present
       time_part = parts[1]
       if !time_part.include?(":")
         self[f] = nil
         break
       elsif time_part.scan(":").length == 1
         time_part = "#{time_part}:00"
       end

       # check time parts
       time_parts = time_part.split(":")
       hr = time_parts[0]
       min = time_parts[1]

       if hr.length != 2 || hr.to_i > 23
         self[f] = nil
         break
       end

       if min.length != 2 || min.to_i > 59
         self[f] = nil
         break
       end

       zone_part = parts[2]
       self[f] = "#{date_part} #{time_part} #{zone_part}"
     end
   end
 end
end

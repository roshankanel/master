class User < ApplicationRecord
    include Formatters
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
   :validatable, :confirmable, :lockable, :timeoutable
  attr_writer :login
  after_create :send_admin_mail
  has_many :user_role_locations

  # after_create :set_default_role
  mattr_accessor :add_message
  mattr_accessor :updated_message
  mattr_accessor :remove_message

  def login
   @login || self.email
  end

  # Fetch the current user
  def self.current
    Thread.current[:user]
  end

  # Assign the current user.
  def self.current=(user)
    Thread.current[:user] = user
  end
  # Find the user from ldap response
  def self.from_omniauth(auth)
    where(provider: auth['provider'], uid: auth['info']['nickname']).first
  end

  # Returns full name
  def full_name
    "#{self.first_name} #{self.last_name}"
  end



  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(email).deliver
  end


  # Checking if user has any roles
  def has_roles?
    if self.user_role_locations.blank?
      false
    else
      true
    end
  end
  # This methods checks if user password expired
  # After user login, the sign_in_count is updated to 1 immediately after first login.
  # When set_password is run, there is an option to force non-ldap user to change password
  # when first time login (by setting the password_change_at to a very old date)
  # Hence do not use sign_in_count to force user to change password here.
  def password_expired?
    # return false if self.provider == 'ldap'     # password expiry validation is not for ldap users

    exp_pwd_after = EXPIRE_PASSWORD_AFTER

    pwd_exp_date = (self.password_changed_at.blank? ? self.created_at : self.password_changed_at) + exp_pwd_after

    pwd_expired = (pwd_exp_date.to_date < Time.now.to_date) ? true : false

    return pwd_expired
  end

  # validate password complexity
  def validate_password_complexity

    if self.password.blank?
      return
    end

    pwd_regexpstr = PASSWORD_REGEXPSTR

    if pwd_regexpstr.match(password).blank?
      self.errors[:password] << "must contain 3 out of these 4 groups: big letters, small letters, digits, and symbols from !@#$%^&*()"
      return
    end

    [self.first_name, self.last_name, self.middle_name, self.preferred_name].each do |name|
      if name.blank? == false && (password.downcase.include? name.downcase)
        self.errors[:password] << "cannot include user name"
        break
      end
    end
  end

 def has_permission_where permission, full_object = false, all_levels = false
   p_id = Permission.find_by(name: permission).id

   # FYI in this case URL = user role locations
   urls = User
     .select("users.id, user_role_locations.id as url_id, user_role_locations.role_id")
     .joins(:user_role_locations => {:role => :permissions})
     .where("permissions.id = ? AND users.id = ?", p_id, self.id)
   url_ids  = urls.pluck("user_role_locations.id")
 end

 def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

 def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  # Role_ids is a hash where key is equal to role_id and value is equal to end_date
  # or nil if not end_dated
  def save_user_roles role_ids = [], end_dates = [], full_name

    unless role_ids.blank?
      loc = self.user_role_locations.where("end_date is ? OR end_date > ?", nil, Time.now).order(:role_id)
      selected_roles = Role.where(:id => role_ids)
      selected_roles_id_array = []
      existing_role_id_array = []
      new_role_id_array = []
      new_roles_end_date = {}
      allRoles = Role.all.to_a
      record_removed = ""
      record_added = ""
      record_updated = ""

      role_ids.each do |r|
        unless r.blank?
          new_roles_end_date[r.to_s] = end_dates[r.to_s]
        end
      end

      selected_roles.each do |r|
        selected_roles_id_array << r.id
      end

      loc.each do |l|

        existing_role_id_array << l.role_id
        match_role = selected_roles_id_array.any? {|rid| rid == l.role_id}
        unless l.end_date.blank?
          match_end_date = (new_roles_end_date[l.role_id.to_s] == (l.end_date.to_time).strftime("%d/%m/%Y %H:%M"))
        else
          match_end_date = (new_roles_end_date[l.role_id.to_s] == l.end_date)
        end

        current_role = allRoles.detect{|c| c.id == l.role_id}
        if match_role
          # leave only or check for end_date to update
          if new_roles_end_date[l.role_id.to_s].blank?
            l.end_date = nil
          else
            l.end_date = DateTime.parse new_roles_end_date[l.role_id.to_s].to_s
          end

          unless match_end_date
            record_updated = record_updated.blank? ? "'" + current_role.name.to_s + "'" : record_updated + ", '" + current_role.name.to_s + "'"
          end
          l.updated_by = full_name
          l.save

        else
          record_removed = record_removed.blank? ? "'" + current_role.name.to_s + "'" : record_removed + ", '" + current_role.name.to_s + "'"
          l.destroy
        end
      end

      if record_removed.include? ","
        record_removed = record_removed + " roles removed for '#{self.full_name}'"
      elsif !record_removed.blank?
        record_removed = record_removed + " role removed for '#{self.full_name}'"
      end

      if record_updated.include? ","
        record_updated = record_updated + " roles successfully updated for '#{self.full_name}'"
      elsif !record_updated.blank?
        record_updated = record_updated + " role successfully updated for '#{self.full_name}'"
      end

      new_role_id_array = (selected_roles_id_array - existing_role_id_array).uniq
      new_role_id_array.each do |r|
        selected_end_date = nil
        current_role = allRoles.detect{|c| c.id == r}
        if new_roles_end_date[r.to_s].blank? == false
          selected_end_date =  DateTime.parse new_roles_end_date[r.to_s].to_s
        end

        rl = UserRoleLocation.create!(:user_id => self.id,
            :role_id => r ,
            :end_date => selected_end_date,
            :created_by => full_name,
            :updated_by => full_name
            )

        record_added = record_added.blank? ? "'" + current_role.name.to_s + "'" : record_added + ", '" + current_role.name.to_s + "'"
      end

      if record_added.include? ","
        # record_added = "Added " + record_added + " Roles"
        record_added = record_added + " roles successfully added for '#{self.full_name}'"
      elsif !record_added.blank?
        record_added = record_added + " role successfully added for '#{self.full_name}'"
      end
		end
    self.add_message = record_added.blank? ? "" : record_added
    self.remove_message = record_removed.blank? ? "" : record_removed
    self.updated_message = record_updated.blank? ? "" : record_updated
	end

end

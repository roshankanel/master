# Provide Role seeds
module StoreConstantSeeds

 modifier = "sys admin - rails seed data"

 store_constant_list = [
   ["0.25", "This is the constants we used to calculate set up price for stores", 0.25],
   ["65", "This is the constants we used to calculate set up price for stores", 65],
   ["1.4", "This is the constants we used to calculate set up price for stores", 1.4]
 ]

 store_constant_list.each do |name, description, constant_val|

   unless StoreConstant.exists?(:name => name) then
      byebug
     StoreConstant.create!(name: name, description: description, constant_value: constant_val,
       created_by: modifier, updated_by: modifier)
   end
 end

end

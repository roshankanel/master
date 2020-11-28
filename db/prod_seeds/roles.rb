# Provide Role seeds
module RoleSeeds

 modifier = "sys admin - rails seed data"

 role_list = [
   ["Super User", "The role that trumps all others!"],
   ["Manager", "Manager role"],
   ["Normal User", "Only allowed to create quotation"]
 ]

 role_list.each do |name, description|
   unless Role.exists?(:name => name) then
     Role.create!(name: name, description: description,
       created_by: modifier, updated_by: modifier)
   end
 end

end

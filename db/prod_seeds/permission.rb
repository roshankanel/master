modifier = "sys admin - rails seed data"

# --- create permission records ---
permissions_list = [
  ["approve user", "Approve user once user is created", "Users"],
  ["read user", "Read only permission for users", "Users"],
  ["assign user role", "Assign roles/permission to the users", "Users"],
  ["view user details", "Show user details", "Users"],
  ["create client", "Create permission for client", "Clients"],
  ["update client", "Update permission for client", "Clients"],
  ["read client", "Read only permission for client", "Clients"],
  ["view client details", "Show client details", "Clients"],
  ["create item", "Create permission for items", "Items"],
  ["update item", "Update permission for items", "Items"],
  ["read item", "Read only permissoin for items", "Items"],
  ["delete item", "Delete permissoin for items", "Items"],
  ["view item details", "Show item details", "Items"],
  ["create role", "Create permission for roles", "Roles and Permission"],
  ["update role", "Update permission for roles", "Roles and Permission"],
  ["read role", "Read only permission for roles", "Roles and Permission"],
  ["view role details", "Show role details", "Roles and Permission"],
  ["create permission", "Create permission for permissions", "Roles and Permission"],
  ["update permission", "Update permission for permissions", "Roles and Permission"],
  ["read permission", "Read only permission for permissions", "Roles and Permission"],
  ["view permission details", "Show permission details", "Roles and Permission"]
]

permissions_list.each do |name, description, gp_name|
  permission = Permission.find_by(name: name)
  if permission.nil? then
    Permission.create!(name: name,
      description: description,
      group_name: gp_name,
      created_by: modifier,
      updated_by: modifier)
  end
end

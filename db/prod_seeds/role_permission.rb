modifier = "sys admin - rails seed data"

  role_perm = [
    ["Super User",["approve user", "read user", "assign user role", "view user details",
      "create client", "update client", "read client", "view client details", "create item",
      "update item", "read item", "view item details", "delete item",
      "create store", "update store", "read store", "view store details", "delete store",
      "create role", "update role", "read role", "view role details", "create permission",
      "update permission", "read permission", "view permission details"]],

    ["Manager", ["approve user", "read user", "view user details", "assign user role",
        "create client", "update client", "read client", "view client details", "create item",
        "update item", "read item", "view item details"]],
    ]

  role_perm.each do |role, perms|
    r = Role.find_by_name(role)
    perms.each do |perm|
      pe = Permission.find_by_name(perm)
      rp = RolePermission.find_by(role_id: r.id, permission_id: pe.id)

      if rp.nil? then
        RolePermission.create!(role_id: r.id, permission_id: pe.id, created_by: modifier, updated_by: modifier)
      end
    end
  end

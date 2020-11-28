modifier = "sys admin - rails seed data"

  role_perm = [
    ["Super User",["approve user", "view user", "assign roles/permission", "view roles/permission", "create client", "update client", "view client", "create item",
      "update item", "view item", "create role", "update role", "view role",
      "create permission", "update permission", "view permission"]],

    ["Manager", ["approve user", "view user", "assign roles/permission", "view roles/permission", "create client", "update client", "view client", "create item",
        "update item", "view item"]],
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

class RolePermissionVersion < PaperTrail::Version
  self.table_name = :role_permission_logs
  default_scope {where.not(event: 'create')}
end

class RoleVersion < PaperTrail::Version
  self.table_name = :role_logs
  default_scope {where.not(event: 'create')}
end

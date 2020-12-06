class PermissionVersion < PaperTrail::Version
  self.table_name = :permission_logs
  default_scope {where.not(event: 'create')}
end

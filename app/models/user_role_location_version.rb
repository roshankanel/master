class UserRoleLocationVersion < PaperTrail::Version
  self.table_name = :user_role_location_logs
  default_scope {where.not(event: 'create')}
end

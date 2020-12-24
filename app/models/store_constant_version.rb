class StoreConstantVersion < PaperTrail::Version
  self.table_name = :store_constant_logs
  default_scope {where.not(event: 'create')}
end

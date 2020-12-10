class StoreVersion < PaperTrail::Version
  self.table_name = :tbl_store_logs
  default_scope {where.not(event: 'create')}
end

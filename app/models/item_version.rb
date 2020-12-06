class ItemVersion < PaperTrail::Version
  self.table_name = :tbl_item_logs
  default_scope {where.not(event: 'create')}
end

class Store < ApplicationRecord
  include Formatters
  self.table_name = 'tbl_stores'
  has_paper_trail versions: { class_name: 'StoreVersion' }
  private

    # Specifies the fields that have some auto formatting, we use this to distinqush
    # formatting changes vs real data changes when updates occur
    def formatted_fields
      {name: ['strip', 'downcase'], description: ['strip']}
    end
end

class StoreType < ApplicationRecord
  include Formatters
  self.table_name = 'store_types'


  
  private

    # Specifies the fields that have some auto formatting, we use this to distinqush
    # formatting changes vs real data changes when updates occur
    def formatted_fields
      {name: ['strip', 'downcase'], description: ['strip']}
    end
end

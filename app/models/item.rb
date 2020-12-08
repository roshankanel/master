class Item < ApplicationRecord
  include Formatters
  self.table_name = 'tbl_items'
  has_paper_trail versions: { class_name: 'ItemVersion' }


  validates_length_of :item_number, maximum: 20, message: "is too long (maximum is 20 digits)"

  private

    # Specifies the fields that have some auto formatting, we use this to distinqush
    # formatting changes vs real data changes when updates occur
    def formatted_fields
      {name: ['strip', 'downcase'], description: ['strip']}
    end
end

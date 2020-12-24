class Store < ApplicationRecord
  include Formatters
  self.table_name = 'tbl_stores'
  has_paper_trail versions: { class_name: 'StoreVersion' }

  before_validation(on: [:create, :update]) do
    #self.name = self.name.downcase.strip unless self.name.blank?
    # Apply formatting
    transform_downcase [:store_type]
    strip_whitespace [:store_type]
  end


  private

    # Specifies the fields that have some auto formatting, we use this to distinqush
    # formatting changes vs real data changes when updates occur
    def formatted_fields
      {name: ['strip', 'downcase'], description: ['strip']}
    end
end

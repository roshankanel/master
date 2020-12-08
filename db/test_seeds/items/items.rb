# Provides Items seeds
module ItemSeeds
require 'csv'
  modifier = "sys admin - rails seed data"

  rel_filepath = "db/test_seeds/items/items.csv"
  CSV.foreach(rel_filepath, headers: true, :col_sep => ',') do |row|
    unless Item.exists?(:item_number => row["ITEM_NUMBER"]) then
       Item.create!(
        item_number: row["ITEM_NUMBER"],
        item_product: row["ITEM_PRODUCT"],
        finished_size: row["FINISHED_SIZE"],
        setup_price: row["Setup"],
        unit_price:  row["Unit_Price"],
        archived:   0,
        created_by: modifier,
        updated_by: modifier)
    end
  end

end

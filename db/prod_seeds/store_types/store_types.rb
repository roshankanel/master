# Provides Items seeds
module Store_typeSeeds

  modifier = "sys admin - rails seed data"

  rel_filepath = "db/prod_seeds/store_types/store_types.csv"
  CSV.foreach(rel_filepath, headers: true, :col_sep => ',') do |row|
    unless StoreType.exists?(:name => row["TYPE"]) then
       StoreType.create!(
        name: row["TYPE"],
        archived:   0,
        created_by: modifier,
        updated_by: modifier)
    end
  end

end

# Provides Stores seeds
module StoreSeeds

  modifier = "sys admin - rails seed data"

  rel_filepath = "db/prod_seeds/stores/stores.csv"
  CSV.foreach(rel_filepath, headers: true, :col_sep => ',') do |row|
    unless Store.exists?(:store_num => row["STORE_NUM"]) then
       Store.create!(
        store_num: row["STORE_NUM"],
        store_type_id: row["TYPE"],
        address: row["ADDRESS"],
        city: row["CITY"],
        postcode:  row["POSTCODE"],

        state_region: row["STATE_REGION"],
        status: row["STATUS"],
        phone_num: row["PHONE"],
        district_manager:  row["DISTRICT_MANAGER"],

        dm_contact_num: row["DM_CONTACT_NUM"],
        is_halal: row["HALAL"],
        is_cafe: row["CAFE"],
        num_of_drivethru: row["NO_OF_DRIVETHRU"],

        archived:   0,
        created_by: modifier,
        updated_by: modifier)
    end
  end

end

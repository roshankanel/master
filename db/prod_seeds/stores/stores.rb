# Provides Stores seeds
module StoreSeeds

  modifier = "sys admin - rails seed data"

  rel_filepath = "db/prod_seeds/stores/stores.csv"
  CSV.foreach(rel_filepath, headers: true, :col_sep => ',') do |row|
    case row["DTD"]
      when "DTD"
        internal_digital = 1
        drive_thru_digital = -1
      when "0DTD"
        internal_digital = 1
        drive_thru_digital = -1
      when "1DT"
        internal_digital = 0
        drive_thru_digital = 0
      when "1DTD"
        internal_digital = 1
        drive_thru_digital = 0
      when "1DTDD"
        internal_digital = 1
        drive_thru_digital = 1
      when "2DT"
        internal_digital = 0
        drive_thru_digital = 0
      when "2DTD"
        internal_digital = 1
        drive_thru_digital = 0
      when "2DTDD"
        internal_digital = 1
        drive_thru_digital = 1
      else
        internal_digital = 0
        drive_thru_digital = 0

    end
    unless row["TYPE"].blank?
      store_type = StoreType.find_by_name(row["TYPE"].downcase)
      unless store_type.blank?
        store_type_id = store_type.id
      else
          store_type_id = nil
      end
    else
      store_type_id = nil
    end
    unless Store.exists?(:store_num => row["STORE_NUM"].to_i) then
       Store.create!(
        store_num: row["STORE_NUM"].to_i,
        store_type_id: store_type_id ,
        address: row["ADDRESS"],
        city: row["CITY"],
        postcode:  row["POSTCODE"].blank? ? 0: row["POSTCODE"],

        state_region: row["STATE_REGION"],
        status:  row["STATUS"].blank? ? "UNKNOWN" : row["STATUS"],
        phone_num: row["PHONE"],
        district_manager:  row["DISTRICT_MANAGER"],

        dm_contact_num: row["DM_CONTACT_NUM"],
        is_halal: row["HALAL"],
        is_cafe: row["CAFE"],
        num_of_drivethru: row["NO_OF_DRIVETHRU"].blank? ? 0: row["NO_OF_DRIVETHRU"],
        internal_digital: internal_digital,
        drive_thru_digital:  drive_thru_digital,
        setup_price: row["SET_UP_PRICE"],
        archived:   0,
        created_by: modifier,
        updated_by: modifier)
    end
  end

end

class CreateTblStore < ActiveRecord::Migration[6.0]
  def up
   create_table :tbl_stores do |t|
       t.integer :store_num, null: false, limit: 6
       t.integer :store_type_id
       t.string :address, limit: 100
       t.string :city, null: false, limit: 50
       t.integer :postcode, null: false, limit: 5
       t.string :state_region, null: false, limit: 20
       t.string :status, null: false, limit: 100
       t.string :phone_num, limit: 100
       t.string :district_manager, limit: 100
       t.string :dm_contact_num, limit: 100
       t.integer :is_halal, null: false, limit: 1
       t.integer :is_cafe, null: false, limit: 1
       t.integer :num_of_drivethru, null: false, limit: 1
       t.integer :archived, limit: 1
       t.timestamps
       t.integer :lock_version
       t.string :created_by, null: false, limit: 200
       t.string :updated_by, null: false, limit: 200
   end

   create_table "tbl_store_logs" do |t|
     t.string   :item_type, :null => false
     t.integer  :item_id,   :null => false
     t.string   :event,     :null => false
     t.string   :whodunnit
     t.text     :object
     t.datetime :created_at
   end

   add_foreign_key :tbl_stores, :store_types
 end

 def down
   drop_table('tbl_stores', if_exists: true)
 end
end

class StoresConstant < ActiveRecord::Migration[6.0]
  def up
    create_table :store_constants do |t|
      t.string :name , null: false, limit: 30
      t.text   :description, null: false
      t.decimal :constant_value, null: false, precision: 10, scale: 2
      t.timestamps
      t.string :created_by, null: false, limit: 200
      t.string :updated_by, null: false, limit: 200
    end
    add_index "store_constants", :name, unique: true, name: "store_constants_idx01"

    create_table "store_constant_logs" do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
  end

  def down
    drop_table('store_constants', if_exists: true)
  end
end

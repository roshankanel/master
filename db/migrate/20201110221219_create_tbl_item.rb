class CreateTblItem < ActiveRecord::Migration[6.0]
  def up
    create_table :tbl_items do |t|
      t.string :item_number, null: false, limit: 20
      t.string :item_product, null: false, limit: 200
      t.string :finished_size, limit: 200
      t.decimal :setup_price, null: false, precision: 10, scale: 2
      t.decimal :unit_price, null: false, precision: 10, scale: 2
      t.integer :include_in_report, limit: 1
      t.integer :archived, limit: 1
      t.timestamps
      t.integer :lock_version
      t.string :created_by, null: false, limit: 200
      t.string :updated_by, null: false, limit: 200
    end
    add_index "tbl_items", :item_number, unique: true, name: "tbl_items_idx01"

    create_table "tbl_item_logs" do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
  end

  def down
    drop_table('tbl_items', if_exists: true)
  end
end

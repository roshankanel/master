class CreateTblItem < ActiveRecord::Migration[6.0]
  def change
    create_table :tbl_items do |t|
      t.string :item_number, null: false, limit: 20
      t.string :item_product, null: false, limit: 200
      t.string :finished_size, limit: 200
      t.decimal :setup_price, null: false, precision: 10, scale: 2
      t.decimal :unit_price, null: false, precision: 10, scale: 2
      t.integer :archived, limit: 1
      t.timestamps
      t.integer :lock_version
      t.string :created_by, null: false, limit: 200
      t.string :updated_by, null: false, limit: 200
    end
  end
end

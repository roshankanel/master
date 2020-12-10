class CreateStoreType < ActiveRecord::Migration[6.0]
  def up
    create_table :store_types do |t|
      t.string :name, limit: 100
      t.integer :archived, limit: 1
      t.timestamps
      t.string :created_by, null: false, limit: 200
      t.string :updated_by, null: false, limit: 200
    end

    create_table "store_type_logs" do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
  end

  def down
    drop_table('store_types', if_exists: true)
  end
end

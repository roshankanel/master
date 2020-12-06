class CreatePermissions < ActiveRecord::Migration[6.0]
  def up
    create_table :permissions do |t|
      t.string :name, null: false, limit: 50
      t.text   :description, null: false
      t.text :group_name, null: false, limit: 100
      t.timestamps
      t.string :created_by, null: false, limit: 200
      t.string :updated_by, null: false, limit: 200
    end
    add_index "permissions", :name, unique: true, name: "permissions_idx01"

    create_table "permission_logs" do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
  end

  def down
    drop_table('permissions', if_exists: true)
  end
end

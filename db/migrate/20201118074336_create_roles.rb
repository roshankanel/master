class CreateRoles < ActiveRecord::Migration[6.0]
  def up
    create_table :roles do |t|
      t.string :name , null: false, limit: 30
      t.text   :description, null: false
      t.timestamps
      t.string :created_by, null: false, limit: 200
      t.string :updated_by, null: false, limit: 200
    end
    add_index "roles", :name, unique: true, name: "roles_idx01"

    create_table "role_logs" do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
  end

  def down
    drop_table('roles', if_exists: true)
  end
end

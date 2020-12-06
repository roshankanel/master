class CreateRolePermisssion < ActiveRecord::Migration[6.0]
  def up
    create_table :role_permissions do |t|
      t.integer :role_id
      t.integer :permission_id
      t.timestamps
      t.string :created_by, null: false, limit: 200
      t.string :updated_by, null: false, limit: 200
    end
    add_foreign_key :role_permissions, :roles
    add_foreign_key :role_permissions, :permissions

    create_table "role_permission_logs" do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
  end

  def down
    drop_table('role_permissions', if_exists: true)
  end
end

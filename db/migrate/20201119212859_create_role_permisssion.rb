class CreateRolePermisssion < ActiveRecord::Migration[6.0]
  def change
      create_table :role_permissions do |t|
        t.integer :role_id
        t.integer :permission_id
        t.timestamps
        t.string :created_by, null: false, limit: 200
        t.string :updated_by, null: false, limit: 200
      end
      add_foreign_key :role_permissions, :roles
    	add_foreign_key :role_permissions, :permissions
    end
end

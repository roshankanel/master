class CreateUserRoleLocation < ActiveRecord::Migration[6.0]
  def up
    create_table :user_role_locations do |t|
      t.integer :role_id
      t.integer :user_id
      t.date    :end_date
      t.timestamps
      t.string :created_by, null: false, limit: 200
      t.string :updated_by, null: false, limit: 200
    end
    add_foreign_key :user_role_locations, :roles
    add_foreign_key :user_role_locations, :users

    create_table "user_role_location_logs" do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
  end

  def down
    drop_table('user_role_locations', if_exists: true)
  end
end

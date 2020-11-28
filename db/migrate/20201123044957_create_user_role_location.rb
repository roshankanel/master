class CreateUserRoleLocation < ActiveRecord::Migration[6.0]
  def change
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
end
end

class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name , null: false, limit: 30
      t.text   :description, null: false
      t.timestamps
      t.string :created_by, null: false, limit: 200
      t.string :updated_by, null: false, limit: 200
    end
  end
end

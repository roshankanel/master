class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.string :name, null: false, limit: 50
      t.text   :description, null: false
      t.text :group_name, null: false, limit: 100
      t.timestamps
      t.string :created_by, null: false, limit: 200
      t.string :updated_by, null: false, limit: 200
    end
  end
end

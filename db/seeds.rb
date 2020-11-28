# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
class AppSeed

  require 'csv'
  @modifier = "sys admin - rails seed data"
# Add your test data here
  if Rails.env == "test"
    # Add your test data here
  else
      require "#{Rails.root}/db/prod_seeds/items/items"
      require "#{Rails.root}/db/prod_seeds/roles"
      require "#{Rails.root}/db/prod_seeds/permission"
      require "#{Rails.root}/db/prod_seeds/role_permission"

  end
end

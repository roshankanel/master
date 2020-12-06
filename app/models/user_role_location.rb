# UserRoleLocation model ties each of these entities together for security purposes.
# As staff can have more than one role, at one or more depots/locations,
# a single user can many records here.
# Also not that staff may be acting in roles temporary, thus we achieve this
# via an optional end_date.
class UserRoleLocation < ApplicationRecord
  include Formatters

  has_paper_trail versions: { class_name: 'UserRoleLocationVersion' }

  self.table_name = "user_role_locations"
  belongs_to :user
  belongs_to :role
  
end

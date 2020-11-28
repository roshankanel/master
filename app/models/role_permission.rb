# RolePermission model allows us to assign permisisons to certain roles.
class RolePermission < ApplicationRecord
  include Formatters


  belongs_to :role
  belongs_to :permission
end

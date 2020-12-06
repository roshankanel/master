# RolePermission model allows us to assign permisisons to certain roles.
class RolePermission < ApplicationRecord
  include Formatters
  has_paper_trail versions: { class_name: 'RolePermissionVersion' }

  belongs_to :role
  belongs_to :permission
end

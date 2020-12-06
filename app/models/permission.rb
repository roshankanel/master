# This is the Permission model. It stores all the permission.
class Permission< ApplicationRecord
  include Formatters
  has_paper_trail versions: { class_name: 'PermissionVersion' }

  before_validation(on: [:create, :update]) do
    #self.name = self.name.downcase.strip unless self.name.blank?
    # Apply formatting
    transform_downcase [:name]
    strip_whitespace [:name, :description]
  end

  has_and_belongs_to_many :roles, :join_table => :role_permissions
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :group_name, :description, presence: true
  before_destroy :has_permission_been_assigned?

  # Checks whether the permission has been assigned
  def has_permission_been_assigned?
    RolePermission.find_by_permission_id(self.id).blank? ? false : true
  end

  private

  # Specifies the fields that have some auto formatting, we use this to distinqush
  # formatting changes vs real data changes when updates occur
  def formatted_fields
    {name: ['strip', 'downcase'], description: ['strip']}
  end

end

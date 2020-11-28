# Role model class, users belong to certain roles e.g.
# Senior Controller, Controller, Depot Manager, Depot Admin, Region Manager etc
# Through user_role_locations we determine what kind of access the current_user
# has throughout the application.
class Role < ApplicationRecord
  include Formatters

  # has_paper_trail versions: { class_name: 'RoleVersion' }

  before_validation(on: [:create, :update]) do
    # self.name = self.name.titleize.strip unless self.name.blank?
    transform_titleize [:name]
    strip_whitespace [:name, :description]
  end

  has_and_belongs_to_many :permissions, :join_table => :role_permissions
  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :description, presence: true
  has_many :user_role_locations

  # case insensitive find eg. Role.ci_find("name", "Driver")
  scope :ci_find, lambda { |attribute, value| where("lower(#{attribute}) = ?", value.downcase).first }

  # Save permissions to role, note that we allow permissions to be completely
  # removed from a role.
  def save_role_permissions permission_ids, full_name
    # Find the role id first
    # Based on role_id delete eveything from role_permissions table
    # Add all the permission checked in the forms to the role_permissions table
    unless permission_ids.blank?
      perms = Permission.find(permission_ids)
      # self.permissions = [] # cannot use this as it does not trigger PaperTrail
      rrp = RolePermission.where(:role_id => self.id).destroy_all
      # We are deleting the permissions first and recreating it
      # Thus we dont need updated_by in role_permissions table
      perms.each do |p|
        rl = RolePermission.create!(:role_id => self.id,
            :permission_id => p.id,
            :created_by => full_name,
            :updated_by => full_name
            )
      end
    else
      # self.permissions = []  # cannot use this as it does not trigger PaperTrail
      rrp = RolePermission.where(:role_id => self.id).destroy_all
    end
  end

  # This will retrun true or false based on roles been assigned or not
  def has_role_been_assigned?
    # UserRoleLocation.find_by_role_id(self.id).blank? ? false : true
    # UserRoleLocation.where("role_id=? and (end_date <= (?) or end_date is ?)",
    #  self.id, date.now(), nil).blank? ? false : true
    # End date doesn't matter, record is not deleted after end date so we need
    # to keep the reference even after the end date
    UserRoleLocation.where("role_id=?", self.id).blank? ? false : true
  end

  private

  # Specifies the fields that have some auto formatting, we use this to distinqush
  # formatting changes vs real data changes when updates occur
  def formatted_fields
    {name: ['strip', 'titleize'], description: ['strip']}
  end


end

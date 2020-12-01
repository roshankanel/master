class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # This will check if the individual has role to perform task.
  def user_has_permission?(permissions)
    # First quick check to see if user is super!
    return true if user_is_super?

    # User is not any sort of super user so now check through their roles
    assignedRoles, perms = [], []
    perms = Permission.where("name in (?)", permissions).pluck('id') unless permissions.blank?
    unless perms.blank?
      role_ids = RolePermission.where("permission_id in (?)",
        perms).pluck('role_id').uniq
      unless role_ids.blank?
        assignedRoles = user.user_role_locations.where("(end_date is ? OR end_date > (?)) AND role_id in (?)",
          nil, DateTime.now.to_date, role_ids)
      end
    end
    assignedRoles.count > 0 ? true : false
  end


  private

  # Checking if the user has Super User role with a location of Global
  # TODO refactor this to use Redis
  def user_is_super?
    super_user = false
    super_user_id = R_SUPER_USER_ID
    user_role_locs = user.user_role_locations.where("(end_date is ? OR end_date > (?))", nil, DateTime.now.to_date)

    user_role_locs.each do |ur|
      if (ur.role_id == super_user_id)
        super_user = true
        break
      end
    end
    return super_user
  end
end

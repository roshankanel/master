# create takes care of new and update takes care of edit
#
class RolePermissionPolicy < ApplicationPolicy
  def assign_roles?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'assign user role'
  end

  def update_permissions?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'assign user role'
  end

  # Only user with 'create hierarchy level' will have access to create
  def save_permissions?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'assign user role'
  end
end

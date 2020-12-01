# create takes care of new and update takes care of edit
#
class RolePermissionPolicy < ApplicationPolicy
  def update_permissions?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'create role'
  end

  def save_permissions?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'create role'
  end

end

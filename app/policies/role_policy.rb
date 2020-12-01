# create takes care of new and update takes care of edit
#
class RolePolicy < ApplicationPolicy

  # Only user with 'read role' will have access to index page
  def index?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'read role'
  end

  # Only user with 'create role' will have access to create
  def create?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'create role'
  end

  # Only user with 'update role' will have access to update
  def update?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'update role'
  end

  # Only user with 'delete role' will have access to destroy
  def destroy?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'delete role'
  end
end

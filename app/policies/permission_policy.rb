# create takes care of new and update takes care of edit
class PermissionPolicy < ApplicationPolicy

  def index?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'read permission'
  end

  def create?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'create permission'
  end

  def show?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'show permission details'
  end

  def update?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'update permission'
  end

  def destroy?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'delete permission'
  end
end

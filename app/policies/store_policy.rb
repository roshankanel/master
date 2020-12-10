# create takes care of new and update takes care of edit
class StorePolicy < ApplicationPolicy

  def index?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'read store'
  end

  def create?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'create store'
  end

  def show?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'view store details'
  end

  def update?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'update store'
  end

  def destroy?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'delete store'
  end
end

# create takes care of new and update takes care of edit
class ItemPolicy < ApplicationPolicy

  def index?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'view item'
  end

  def create?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'create item'
  end

  def update?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'update item'
  end

  def destroy?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'delete item'
  end
end

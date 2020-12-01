class UserPolicy < ApplicationPolicy
  def index?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'read user'
  end

  def show?
    user_has_permission? 'view user details'
  end

  def create?
    # if you want to pass multiple parameters follow it by commas
    user_has_permission? 'create user'
  end

  # def update?
  #   # if you want to pass multiple parameters follow it by commas
  #   user_has_permission? 'update user'
  # end
  #
  # def destroy?
  #   # if you want to pass multiple parameters follow it by commas
  #   user_has_permission? 'delete user'
  # end

  def show_roles?
    user_has_permission? 'assign user role'
  end

  def unlock_user_account?
    user_has_permission? 'unlock user account'
  end

  def approve_user?
    user_has_permission? 'approve user'
  end
end

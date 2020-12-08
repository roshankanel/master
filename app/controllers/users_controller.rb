class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action do set_active_main_menu "users" end
    before_action :set_current_user
    after_action :verify_authorized, only: [:index, :create, :update, :destroy, :update_approve, :save_roles]
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActionController::UnknownFormat, with: :Unknown_Format


  def index
    authorize User
    @users = User.all
    unless search_user_params.blank?
      @users = User.all
      first_name = search_user_params["first_name"] unless search_user_params["first_name"].blank?
      unless first_name.blank?
        @users = @users.where("first_name = ?", first_name)
      end

      last_name = search_user_params["last_name"] unless search_user_params["last_name"].blank?
      unless last_name.blank?
        @users = @users.where("last_name = ?", last_name)
      end

      email = search_user_params["email"] unless search_user_params["email"].blank?
      unless email.blank?
        @users = @users.where("email = ?", email)
      end

      approved = search_user_params["approved"] unless search_user_params["approved"].blank?
      unless approved.blank?
        approved = (approved.downcase == "true") ? 1 : 0
        @users = @users.where("approved = ?", approved)
      end
      @users = @users.order("first_name", "last_name")
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def show_roles
    @user = User.find(params[:id])
    authorize @user
    @users = User.joins(:user_role_locations).where("user_id =? and (end_date is ? or end_date>?) ", params[:id], nil, Date.today)
    @role_names = {}
    @allroles = Role.all
    @existing_roles = @user.has_roles? ? @user.user_role_locations.where("end_date is ? OR end_date > (?)",
      nil, DateTime.now.to_date).order(:id).pluck(:role_id, :end_date) : []
    Role.select(:id, :name).all.map{|r| @role_names[r.id] = r.name}
  end

  def update_approve
    authorize User
    @user = User.find(params[:id])
    if @user.approved == 0 then
      @user.update(approved: 1)
    else
      @user.update(approved: 0)
    end
  end

# Find the role id first
# Based on role_id delete eveything from role_permissions table
# Add all the permission checked in the forms to the role_permissions table
def save_roles
  @user = User.find(params[:id])
  authorize @user
  if user_role_params[:role_ids]
    if @user.save_user_roles(user_role_params[:role_ids], user_role_params[:end_dates], current_user.full_name)
      flash.now[:context] = "inline"
      flash.now[:success] = []
      flash.now[:success] << @user.add_message unless @user.add_message.blank?
      flash.now[:success] << @user.remove_message unless @user.remove_message.blank?
      flash.now[:success] << @user.updated_message unless @user.updated_message.blank?
      flash.now[:new_location] = user_role_params[:new_location]
      render "row"
    else
      flash.now[:error] = @user.errors.full_messages
      @error_msg = @user.errors.messages
      render "edit_user_roles"
    end
  else
    # TODO flash error
  end
end


  private

    # Whitelist the parameters we know/expect for search, array must be at the end of the list
    def search_user_params
      params.permit(:id, :first_name, :last_name, :email, :approved)
    end

    def user_role_params
      roles = []
      Role.all.pluck(:id).map{|r| roles << r.to_s}
      params.require(:user).permit(:name, :user_id, :lock_version, :reporting_group_id, :new_location, end_dates: [roles], role_ids: [])
    end
end

# The Permission Controller class facilitates the crud actions on
# permission model.
# CRUD actions are triggered from within the permission index page
class PermissionsController < ApplicationController
  before_action :authenticate_user!
  before_action do set_active_main_menu "roles" end
  before_action :get_permission_groups, only: [:new, :create, :show, :edit, :update, :destroy]
  after_action :verify_authorized, only: [:index, :create, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::UnknownFormat, with: :Unknown_Format
  rescue_from ActiveRecord::StaleObjectError, with: :stale_object_error

  # Displays all permissions
  def index
    if flash[:success_id]
      @permissions = Permission.all.order(updated_at: :desc)
    else
      @permissions = Permission.all.order(:name)
    end
    authorize @permissions
    @permission_grps = Permission.distinct.pluck(:group_name).reject{|ele| ele.blank?}.sort

    if ! search_permission_params.blank?
      group_name = search_permission_params["group_name"]
      unless group_name.blank?
        @permissions = @permissions.where("group_name = ? ", \
                                        "#{group_name}")
      end
      name = search_permission_params["name"]
      unless name.blank?
        @permissions = @permissions.where("lower(name) like ? ", \
                                        "%#{name.downcase}%")
      end
      description = search_permission_params["description"]
      unless description.blank?
        @permissions = @permissions.where("lower(description) like ? ", \
                                        "%#{description.downcase}%")
      end
    end # search_permission_params filter ends here
  end

  # Displays selected permission
  def show
    @assigned_roles = ""
    @permission = Permission.find(params[:id])

    unless @permission.roles.blank?
      @permission.roles.each do |p|
        if @assigned_roles == ""
          @assigned_roles = p.name
        else
          @assigned_roles = p.name + ", " + @assigned_roles
        end
      end
    end
  end

  # New modal, gets triggered from within user page
  def new
    @permission = Permission.new
    @error_msg = @permission.errors.messages
  end

  # Create saves the permission
  def create
    @permission = Permission.new(permission_params)
    if authorize @permission
      @permission.set_modifiers current_user
      if @permission.save
        flash[:context] = "inline"
        flash[:success] = "Permission '#{@permission.name}' successfully created."
        flash[:success_id], flash[:row_id] = @permission.id, @permission.id

        render 'row'
      else
        flash.now[:error] = @permission.errors.full_messages
        @error_msg = @permission.errors.messages
        render 'new'
      end
    end
  end

  # Edit modal, gets triggered from within user page
  def edit
    @permission = Permission.find(params[:id])
    @error_msg = @permission.errors.messages
  end

  # Update saves the permission.
  def update
    @permission = Permission.find(params[:id])
    if authorize @permission
      changed = @permission.contains_changes?(permission_params)
      @permission.set_modifiers current_user if changed
      if changed && @permission.update(permission_params)
        flash[:context] = "inline"
        flash[:success] =  "Permission '#{@permission.name}' successfully updated."
        flash[:success_id], flash[:row_id] = @permission.id, @permission.id
        render 'row'
      else
        @permission.errors[:base] << "No changes made" unless changed
        flash.now[:error] = @permission.errors.full_messages
        @error_msg = @permission.errors.messages
        render 'edit'
      end
    end

  end

  # Destroy deletes the permission record
  def destroy
    @permission = Permission.find(params[:id])
    if authorize @permission
      if @permission.has_permission_been_assigned?
        flash[:context] = "permission"
        flash.now[:error] = "Cannot delete permission as it has already been assigned to a role."
        @error_msg = @permission.errors.messages
        render 'edit'
      else
        if @permission.destroy
          flash.now[:notice] = "Permission '#{@permission.name}' successfully deleted."
          render 'row'
        end
      end
    end
  end

  # Get all current permission groups
  def get_permission_groups
    @permission_grps = Permission.distinct.pluck(:group_name).reject{|ele| ele.blank?}.sort
    @permission_grps = [""] + @permission_grps.reject{|ele| ele.empty?}
  end


  private

    # Whitelist the parameters we know/expect
    def permission_params
      params.require(:permission).permit(:id, :group_name, :name, :description)
    end

    # Whitelist the parameters we know/expect for search, array must be at the end of the list
    def search_permission_params
      params.permit(:group_name, :name, :description)
    end


end

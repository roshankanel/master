# The Role Controller class facilitates the crud actions on
# role model.
# CRUD actions are triggered from within the permission index page
class RolesController < ApplicationController
  before_action :authenticate_user!
  before_action do set_active_main_menu "roles" end
  before_action :set_current_user

  # after_action :verify_authorized, only: [:index, :create, :update, :destroy, :update_permissions, :save_permissions]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::UnknownFormat, with: :Unknown_Format

  # Displays all roles
  def index
    # authorize Role
    # if flash[:success_id]
    #   @roles = Role.all.order("id = #{flash[:success_id]} desc, name asc").paginate(page: params[:page], per_page: 10)
    # else
    #   @roles = Role.all.order(:name).paginate(page: params[:page], per_page: 10)
    # end
    #
    # @pages = [10,20,30,40,50,60,70,80,90,100,1000]
    # @per_page = params[:per_page] || 20
    @roles = Role.all.order(:name)

    # authorize @roles
    # if @per_page.blank?
    #    @roles = @roles.paginate(:page => params[:page], :per_page => 10, :total_entries => @roles.length)
    # else
    #   if @per_page == "Show All"
    #     @per_page = @roles.length
    #     @roles = @roles.paginate(:page => params[:page], :per_page => @roles.length, :total_entries =>@roles.length)
    #   else
    #     @roles = @roles.paginate(:page => params[:page], :per_page => @per_page, :total_entries =>@roles.length)
    #   end
    # end
  end

  # Displays selected roles
  def show
    @role = Role.find(params[:id])
    # @roles = Role.paginate(page: params[:page], per_page: 10)
    @existing_perms_name = Role.find(params[:id]).permissions.collect{|r| r.name}.join ', '

    @permissions = Permission.all.order(:group_name, :name)
    @existing_perms = Role.find(params[:id]).permissions.pluck(:id)
    # just get groups with permissions
    groups = Role.find(params[:id]).permissions.pluck(:group_name).uniq.sort
    @perm_groups = {"Other" => []}
    groups.each do |g|
      @perm_groups[g] = []
    end
    @permissions.each do |p|
      if p.group_name.blank?
        @perm_groups["Other"] << p
      else
        # ignore those without key as they are not to be displayed
        if @perm_groups.key?(p.group_name)
          @perm_groups[p.group_name] << p
        end
      end
    end
  end  # def show ends here

  # New modal, gets triggered from within user page
  def new
    @role= Role.new
    @error_msg = @role.errors.messages
  end

  # Create saves the role
  def create
    @role = Role.new(role_params)
    @role.set_modifiers current_user
    # if authorize @role
      if @role.save
        flash[:context] = "inline"
        flash[:success] = "Role '#{@role.name}' successfully created."
        flash[:success_id], flash[:row_id] = @role.id, @role.id
        render 'row'
      else
        flash.now[:error] = @role.errors.full_messages
        @error_msg = @role.errors.messages
        render 'new'
      end
    # end
  end

  # Edit modal, gets triggered when press the Edit button next to a show
  def edit
    @role = Role.find(params[:id])
    @permissions = Permission.all
    @error_msg = @role.errors.messages
  end

  # Update saves the role
  def update
    @role = Role.find(params[:id])
    changed = @role.contains_changes?(role_params)
    @role.set_modifiers current_user if changed
    # @can_update_role = authorize @role
    # if @can_update_role
      @current_user = current_user
      if changed && @role.update(role_params)
        flash[:context] = "inline"
        flash[:success] = "Role '#{@role.name}' successfully updated."
        flash[:success_id], flash[:row_id] = @role.id, @role.id
        render 'row'
      else
        @role.errors[:base] << "No changes made" unless changed
        flash.now[:error] = @role.errors.full_messages
        @error_msg = @role.errors.messages
        render 'edit'
      end
    # end
  end

  # Destroy deletes the role
  # Deletes only if it is not assigned to permission
  def destroy
    @role = Role.find(params[:id])
    # if authorize @role
      if @role.has_role_been_assigned?
        flash.now[:error] = "Cannot delete role when it is being assigned."
        render 'edit'
      else
        if @role.destroy
          flash.now[:notice] = "Role '#{@role.name}' successfully deleted"
          render 'row'
        end
      end
    # end
  end

  # update permission for the selected role
  def update_permissions
    # if authorize RolePermission
      @role = Role.find(params[:role_id])
      @permissions = Permission.all.order(:group_name, :name)
      @existing_perms = Role.find(params[:role_id]).permissions.pluck(:id)
      groups = Permission.all.group(:group_name).order(:group_name).pluck(:group_name)
      @perm_groups = {"Other" => []}
      groups.each do |g|
        @perm_groups[g] = []
      end
      @permissions.each do |p|
        if p.group_name.blank?
          @perm_groups["Other"] << p
        else
          @perm_groups[p.group_name] << p
        end
      end
      render 'permissions'
    # end
  end

  # save permission for the selected role
  def save_permissions
    # Find the role id first
    # Based on role_id delete eveything from role_permissions table
    # Add all the permission checked in the forms to the role_permissions table
    # if authorize RolePermission
      @role = Role.find(params[:role_id])
      @role.set_modifiers current_user
      if params[:role] && params[:role][:permission_ids]
        if @role.save_role_permissions params[:role][:permission_ids], current_user.full_name
          # flash[:notice] = "Permission(s) successfully assigned to the #{@role.name} role." unless @role.permissions.blank
          flash[:context] = "inline"
          flash.now[:success] = "Permission(s) successfully assigned to the #{@role.name} role."
          flash.now[:success_id], flash.now[:row_id] = @role.id, @role.id
          # TODO Should we explicitly require some kind of token value for permission removal?
          # flash[:notice] = "All permission(s) for the #{@role.name} role has been removed." if @role.permissions.blank?
        end
      else
        @role.save_role_permissions [], current_user.full_name
        # flash[:notice] = "All permission(s) for the #{@role.name} role has been removed."
        flash[:context] = "inline"
        flash.now[:success] = "All permission(s) for the #{@role.name} role has been removed."
        flash.now[:success_id], flash.now[:row_id] = @role.id, @role.id
      end
      # redirect_to :action => "index"
      render 'row'
    # end
  end

  private

    # Whitelist the parameters we know/expect
    def role_params
      params.require(:role).permit(:name, :id, :description)
    end
    # Whitelist the parameters we know/expect for search
    def search_roles_params
      params.permit(:name, :description)
    end
end

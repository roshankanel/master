# The items Controller class facilitates the crud actions on
# item model.
# CRUD actions are triggered from within the item index page
class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action do set_active_main_menu "items" end
  # after_action :verify_authorized, only: [:update, :create, :destroy]
  # after_action :verify_policy_scoped, only: :index
  # skip_after_action :verify_authorized
  # after_action :verify_authorized, only: [:index, :create, :update, :destroy]
  before_action :retrieve_item, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActionController::UnknownFormat, with: :Unknown_Format
  rescue_from ActiveRecord::StaleObjectError, with: :stale_object_error
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

  def index
    @items = Item.all
    unless search_item_params.blank?
      @items = Item.all
      item_number = search_item_params["item_number"] unless search_item_params["item_number"].blank?
      unless item_number.blank?
        @items = @items.where("item_number = ?", item_number)
      end

      item_product = search_item_params["item_product"] unless search_item_params["item_product"].blank?
      unless item_product.blank?
        @items = @items.where("item_product = ?", item_product)
      end

      finished_size = search_item_params["finished_size"] unless search_item_params["finished_size"].blank?
      unless finished_size.blank?
        @items = @items.where("finished_size = ?", finished_size)
      end

      archived = search_item_params["archived"] unless search_item_params["archived"].blank?
      unless archived.blank?
        archived = (archived.downcase == "true") ? 1 : 0
        @items = @items.where("archived = ?", archived)
      end
      @items = @items.order("item_product")
    end
  end

  def new
    @item = Item.new
    @error_msg = @item.errors.messages
  end

  # Create saves the items
  def create
    @item = Item.new(item_params)
    # if authorize @permission
      @item.set_modifiers current_user
      if @item.save
        flash[:context] = "inline"
        flash[:success] = "Item '#{@item.item_number}' successfully created."
        flash[:success_id], flash[:row_id] = @item.id, @item.id

        render 'row'
      else
        flash.now[:error] = @item.errors.full_messages
        @error_msg = @item.errors.messages
        render 'new'
      end
    # end
  end

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
end

def edit
  @item = Item.find(params[:id])
  @error_msg = @item.errors.messages
end

def update
  @item = Item.find(params[:id])
  # if authorize @permission
    changed = @item.contains_changes?(item_params)
    @item.set_modifiers current_user if changed
    if changed && @item.update(item_params)
      flash[:context] = "inline"
      flash[:success] =  "Item '#{@item.item_number}' successfully updated."
      flash[:success_id], flash[:row_id] = @item.id, @item.id
      render 'row'
    else
      @item.errors[:base] << "No changes made" unless changed
      flash.now[:error] = @item.errors.full_messages
      @error_msg = @item.errors.messages
      render 'edit'
    end
  # end
end

# Destroy deletes the permission record
  def destroy
    @item = Item.find(params[:id])
    # if authorize @permission
    if @item.destroy
      flash.now[:notice] = "Permission '#{@item.item_number}' successfully deleted."
      render 'row'
    end
    #end
  end

  private

  # Retrieves the country record
  def retrieve_item
    @item = Item.find(params[:id])
  end

  # Whitelist the parameters we know/expect
  def item_params
    params.require(:item).permit(:item_number, :item_product, :finished_size, :setup_price, :unit_price, :archived,
      :lock_version)
  end

  # Whitelist the parameters we know/expect for search, array must be at the end of the list
  def search_item_params
    params.permit(:item_number, :item_product, :finished_size, :archived)
  end

end

# The stores Controller class facilitates the crud actions on
# stores model.
# CRUD actions are triggered from within the store index page
class StoresController < ApplicationController
  before_action :authenticate_user!
  before_action do set_active_main_menu "stores" end
  # after_action :verify_authorized, only: [:update, :create, :destroy]
  # after_action :verify_policy_scoped, only: :index
  # skip_after_action :verify_authorized
  # after_action :verify_authorized, only: [:index, :create, :update, :destroy]
  before_action :retrieve_store, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActionController::UnknownFormat, with: :Unknown_Format
  rescue_from ActiveRecord::StaleObjectError, with: :stale_object_error
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

  def index
    @stores = Store.all
    @types = StoreType.all
    @states = Store.select(:state_region).distinct
    @status = Store.select(:status).distinct
    unless search_store_params.blank?
      @stores = Store.all
      store_num = search_store_params["store_num"] unless search_store_params["store_num"].blank?
      unless store_num.blank?
        @stores = @stores.where("store_num = ?", store_num)
      end
      city = search_store_params["city"] unless search_store_params["city"].blank?
      unless city.blank?
        @stores = @stores.where("city = ?", city)
      end
      state_region = search_store_params["state_region"] unless search_store_params["state_region"].blank?
      unless state_region.blank?
        @stores = @stores.where("state_region = ?", state_region)
      end
    store_type_id = search_store_params["store_type_id"] unless search_store_params["store_type_id"].blank?
      unless store_type_id.blank?
        @stores = @stores.where("store_type_id = ?", store_type_id)
      end
      status = search_store_params["status"] unless search_store_params["status"].blank?
        unless status.blank?
          @stores = @stores.where("status = ?", status)
        end
      @stores = @stores.order("store_num")
    end
  end

## Add New Store
  def new
    @store = Store.new
    @types = StoreType.all
    @states = Store.order(:state_region).pluck(:state_region).uniq
    @status = Store.order(:status).pluck(:status).uniq
    @error_msg = @store.errors.messages
  end

  # Create saves the stores
  def create
    @store = Store.new(store_params)

    # if authorize @permission
      @store.set_modifiers current_user
      if @store.save
        flash[:context] = "inline"
        flash[:success] = "Store '#{@store.store_num}' successfully created."
        flash[:success_id], flash[:row_id] = @store.id, @store.id
        render 'row'
      else
        flash.now[:error] = @store.errors.full_messages
        @error_msg = @store.errors.messages
        render 'new'
      end
    # end
  end
  def show
    @store = Store.find(params[:id])
    @store_type = StoreType.find(@store.store_type_id)
  end

  def edit
    @store = Store.find(params[:id])
    @types = StoreType.all
    @error_msg = @store.errors.messages
  end

  def update
    @store = Store.find(params[:id])
    # if authorize @permission
      changed = @store.contains_changes?(store_params)
      @store.set_modifiers current_user if changed
      if changed && @store.update(store_params)
        flash[:context] = "inline"
        flash[:success] =  "Store '#{@store.store_num}' successfully updated."
        flash[:success_id], flash[:row_id] = @store.id, @store.id
        render 'row'
      else
        @store.errors[:base] << "No changes made" unless changed
        flash.now[:error] = @store.errors.full_messages
        @error_msg = @store.errors.messages
        render 'edit'
      end
    # end
  end

  # Destroy deletes the permission record
    def destroy
      @store = Store.find(params[:id])
      # if authorize @permission
      if @store.destroy
        flash.now[:notice] = "Permission '#{@store.store_num}' successfully deleted."
        render 'row'
      end
    end

    private

    # Retrieves the country record
    def retrieve_store
      @store = Store.find(params[:id])
    end


    # Whitelist the parameters we know/expect
    def store_params
      params.require(:store).permit(:store_num, :address, :city, :postcode, :state_region,:store_type_id, :status,
        :phone_num, :district_manager, :dm_contact_num, :is_halal, :is_cafe, :num_of_drivethru,:archived, :lock_version)
    end

    # Whitelist the parameters we know/expect for search, array must be at the end of the list
    def search_store_params
      params.permit(:store_num, :address, :city, :postcode, :state_region, :status,
        :phone_num, :district_manager, :dm_contact_num, :archived, :store_type_id)
    end
end

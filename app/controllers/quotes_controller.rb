# The quotes Controller class facilitates generate the quotes
class QuotesController < ApplicationController
  before_action :authenticate_user!
  before_action do set_active_main_menu "quotes" end
  before_action :retrieve_item, only: [:index]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActionController::UnknownFormat, with: :Unknown_Format
  rescue_from ActiveRecord::StaleObjectError, with: :stale_object_error
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

  def index

  end



  private

  # Retrieves the item record
  def retrieve_item
    @items = Item.where("include_in_report=?", 1).order(:item_product)
    @regions = Store.select(:state_region).distinct
  end

end

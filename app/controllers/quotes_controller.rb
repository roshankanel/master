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

  def add_quote
    constant_values = StoreConstant.where("archived=?", 0)
    kitpack_freight_consolidation = 0
    item_product_code = params[:item_product_code]
    item = Item.where("item_number =?", item_product_code).first
    item_product = params[:item_product]
    regions = params[:regions]
    quantity = params[:quantity]
    time_slot = params[:time_slot]
    dead_line =  Date.parse(params[:dead_line]).strftime(" %d-%m-%Y")
    dtdigital = params[:dtdigital] == 'true'? 0 : 1
    indigital = params[:indigital] == 'true'? 0 : 1
    quote_filter = params[:quote_filter] == 'true'? 1 : 0
    store_type = []
    if indigital == 1
      store_type << "Digital Internal"
    else
      store_type << "Non Digital Internal"
    end
    if dtdigital == 1
      store_type << "Digital Drive Thru's"
    else
      store_type << "Non Digital Drive Thru's"
    end

    unless quote_filter == 0
      exclude_halal = params[:exclude_halal] == 'true'? 1 : 0
      halal_only = params[:halal_only] == 'true'? 1 : 0
      exclude_cafe = params[:exclude_cafe] == 'true'? 1 : 0
      cafe_only = params[:cafe_only] == 'true'? 1 : 0
      exclude_mulitplier = params[:exclude_mulitplier] == 'true'? 1 : 0
      multiplier_only = params[:multiplier_only] == 'true'? 1 : 0
      unless exclude_halal == 0
        store_type << "Exclude Halal"
      end
      unless halal_only == 0
        store_type << "Halal Only"
      end
      unless exclude_cafe == 0
        store_type << "Exclude Cafe"
      end
      unless cafe_only == 0
        store_type << "Cafe Only"
      end
      unless exclude_mulitplier == 0
        store_type << "Exclude Mulitplier"
      end
      unless multiplier_only == 0
        store_type << "Multiplier Only"
      end
    end
    region_array = regions.split(",").map(&:strip)
    unless quote_filter == 1
      store = Store.where("state_region in (?)  and (internal_digital=? and drive_thru_digital=?) and status=?"\
        , region_array, indigital, dtdigital, 'Trading')
    else
      if exclude_halal == 1
        store = Store.where("state_region in (?) and is_halal=? and (internal_digital=? and drive_thru_digital=?) and status=?"\
          , region_array, 0, indigital, dtdigital, 'Trading')
      elsif halal_only == 1
        store = Store.where("state_region in (?) and is_halal=? and (internal_digital=? and drive_thru_digital=?) and status=?"\
          , region_array, 1, indigital, dtdigital, 'Trading')
      elsif exclude_cafe == 1
        store = Store.where("state_region in (?) and is_cafe=? and (internal_digital=? and drive_thru_digital=?) and status=?"\
          , region_array, 0, indigital, dtdigital, 'Trading')
      elsif cafe_only == 1
        store = Store.where("state_region in (?) and is_cafe=? and (internal_digital=? and drive_thru_digital=?) and status=?"\
          , region_array, cafe_only, indigital, dtdigital, 'Trading')
      elsif exclude_mulitplier ==1
        store = Store.where("state_region in (?) and multiplier=? and (internal_digital=? and drive_thru_digital=?) and status=?"\
          , region_array, 0, indigital, dtdigital, 'Trading')
      elsif multiplier_only == 1
        store = Store.where("state_region in (?) and multiplier=? and (internal_digital=? and drive_thru_digital=?) and status=?"\
          , region_array, multiplier_only, indigital, dtdigital, 'Trading')
      else
        store = Store.where("state_region in (?)  and (internal_digital=? and drive_thru_digital=?) and status=?"\
          , region_array, indigital, dtdigital, 'Trading')
      end
    end
    constant_1 = constant_values.find_by_name("0.25").constant_value
    constant_2 = constant_values.find_by_name("6.5").constant_value
    constant_3 = constant_values.find_by_name("1.4").constant_value
    store.each do |st|
      kitpack_freight_consolidation += ((quantity.to_i*constant_1 + constant_2) + (st.setup_price+constant_3))
    end
    total_stores = store.count() * time_slot.to_i + quantity.to_i
    total_price = (item.setup_price + (item.unit_price * total_stores)) unless item.blank?
    render json: {item: item, store_type: store_type.to_sentence, total_stores: total_stores, total_price: total_price, kitpack_freight_consolidation: kitpack_freight_consolidation, dead_line: dead_line}, status: :ok
  end


  private

  # Retrieves the item record
  def retrieve_item
    @items = Item.where("include_in_report=?", 1).order(:item_product)
    @regions = Store.select(:state_region).order(:state_region).distinct
  end

end

class ApplicationController < ActionController::Base
  # include Pundit
  # rescue from StandardError MUST be first on the list otherwise it will
  # overide all other resuce froms
  rescue_from StandardError, with: :other_error
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_authenticity_token
  protect_from_forgery with: :exception
  # before_action :set_paper_trail_whodunnit
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?  # testing 1 and 2

  protected

  # Additional whitelist of params accepted for devise sign up
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :first_name, :last_name])
  end

  # Overrides the devise method - after_sign_in_path_for to
  # - check for expired passwords
  # - setup user.id cookies
  def after_sign_in_path_for(resource)
    cookies.signed['user.id'] = {
      :value => resource.id
    }
    pwd_expired = current_user.password_expired?  # method in User model
      if pwd_expired
      flash[:error] = ""
      flash.now[:error] << "Password expired. Please change password."
      renew_password_path(current_user.id)
    else
      # must not resume last page for selenium/test or the display after login will be unpredictable
      if Rails.application.config.resume_last_page == "Y"
        session[:previous_url] || root_path  # return to the previous location otherwise to the root path
      else
        root_path
      end
    end
  end

  # Hook into the devise method - after_sign_out_path_for to delete user.id cookie
  def after_sign_out_path_for(resource_or_scope)
    cookies.delete 'user.id'
    super
  end


  private

  # controls when a location can be stored
  def storable_location?
    # for selenium and test env, must check is_navigational_format? && !request.xhr?
    request.get? && !devise_controller?
  end

  # stores user location so as to returns to that page when log in after timeout
  def store_user_location!
    cur_path = request.fullpath
    if cur_path == "/"
      cur_path = request.referer
    end
    if not (cur_path =~ /\/users/)
      session[:previous_url] = cur_path
    end
  end

  # called from the controllers to catch all other exceptions and handle
  # exceptions thrown during an ajax request
  def other_error exception
    if request.xhr? == 0
      # request is ajax
      byebug
      read_error_log = current_user.has_permission_where "read error logs"
      @show_error_log_link = read_error_log.blank? ? "false" : "true"
      # log the error in the db with our own exception model
      referrer = request.referer || "unknown"
      user_agent = request.user_agent || "unknown"
      @exception = ErrorLog.create!({
        :class_name => exception.class.to_s,
        :status => ActionDispatch::ExceptionWrapper.new(request.env, exception).status_code,
        :message => exception.message,
        :trace => exception.backtrace.join("\n"),
        :target => request.url,
        :referrer => referrer,
        :params => request.params.inspect,
        :user_agent => user_agent,
        :user_id => current_user.id
        })

      # render JS file to update error message on modal
      render 'layouts/exception_raised.js'

    else
      # request is not ajax
      # re-raise exception and continue dealing with it as normal
      raise
    end
  end

  # Called from rescue of Activerecord record not found errors
  def record_not_found exception
    result = exception.message.match /Couldn't find ([\w]+) with 'id'=([\d]+)/
    flash[:error] = exception.message
    if request.xhr? == 0
      # ajax
      render js: 'window.location.href = "/";'
    else
      redirect_to :action => "index"
    end
  end

  # Called from rescue of Activecontroller template not found errors
  def unknown_format
    flash[:error] = "Format or template not found"
    redirect_to :action => "index"
  end

  # Called from rescue of Activerecord stale object errors
  def stale_object_error
    flash[:error] = "#{$!.message} \
      The record has been changed by another user/process while \
      you were trying to edit it. Reopen to have the latest version and try to \
      edit again if your changes are still required."
    # redirect_to :action => "index"
    if request.xhr? == nil
      redirect_to(request.referrer || root_path)
    else
      referrer = request.referrer || root_path
      render :js => "window.location = '#{referrer}';"
    end
  end

  # called from rescue of activerecord invalid authenticity token
  def invalid_authenticity_token
    flash[:error] = "Invalid authenticity token. Please refresh the page and try again, \
      or close and reopen your browser. If the problem persists, please contact \
      the software development team."
    if request.xhr? == nil
      redirect_to(request.referrer || root_path)
    else
      referrer = request.referrer || root_path
      render :js => "window.location = '#{referrer}';"
    end
  end

  def invalid_foreign_key
    flash[:error] = "Child record found. Please first delete all the associated record"
    redirect_to :action => "index"
  end

  # set the active main menu, default is home menu item
  def set_active_main_menu top_level = "home"
    @active_menu = top_level
  end

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action. Please speak to your manager if you require access."
    if request.xhr? == nil
      redirect_to(request.referrer || root_path)
    else
      referrer = request.referrer || root_path
      render :js => "window.location = '#{referrer}';"
    end
  end

  # Set the current user so that we can access it from models if we
  def set_current_user
     User.current = current_user
  end

end

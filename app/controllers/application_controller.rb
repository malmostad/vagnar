class ApplicationController < ActionController::Base
  include Catchable

  protect_from_forgery with: :exception
  authorize_resource
  check_authorization

  before_action :authenticate
  before_action :log_user_on_request
  before_action { add_body_class("#{controller_name} #{action_name}") }
  before_action :init_body_class

  SESSION_TIME = APP_CONFIG['session_time']

  def current_user
    @current_user ||= User.find(session[:user_id])
  rescue
    User.new
  end
  helper_method :current_user

  def authenticate
    return true if current_user.has_role?(:admin)

    if current_user.has_role?(:seller) && session_fresh?
      update_session
    else
      remember_requested_url
      redirect_to saml_login_path
    end
  end

  def authenticate_admin
    if current_user.has_role?(:admin) && session_fresh?
      update_session
    else
      remember_requested_url
      redirect_to administrera_path
    end
  end

  def reset_session_keys
    reset_session
    session[:renewed_at] = nil
    session[:user_id]    = nil
  end

  def session_fresh?
    session[:renewed_at] && session[:renewed_at].to_time > Time.now - SESSION_TIME.minutes
  end

  def update_session
    logger.debug 'Updated session'
    session[:renewed_at] = Time.now
  end

  # Remember where the user was about to go
  def remember_requested_url
    return if request.xhr?
    session[:requested_url] = request.fullpath
  end

  def redirect_after_login
    if session[:requested_url]
      requested_url = session[:requested_url]
      session[:requested_url] = nil
      redirect_to requested_url
    else
      redirect_to root_path
    end
  end

  def init_body_class
    add_body_class(Rails.env) unless Rails.env.production?
    add_body_class(current_user.role)
  end

  # Adds classnames to the body tag
  def add_body_class(name)
    @body_classes ||= ''
    @body_classes << "#{name} "
  end
end

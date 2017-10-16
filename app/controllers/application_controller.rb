class ApplicationController < ActionController::Base
  include Catchable

  protect_from_forgery with: :exception

  SESSION_TIME = APP_CONFIG['session_time']

  before_action { add_body_class("#{controller_name} #{action_name}") }
  before_action :init_body_class

  def current_user
    @current_user ||= User.find(session[:user_id])
  rescue
    User.new
  end

  helper_method :current_user

  def authenticate
    if !current_user.has_role?(:seller, :admin) || session_expired?
      remember_requested_url
      redirect_to session_path
    end
    update_session
  end

  def authenticate_admin
    if !current_user.has_role?(:admin) || session_expired?
      remember_requested_url
      redirect_to admin_session_path
    end
    update_session
  end

  # Remember where the user was about to go
  def remember_requested_url
    return if request.xhr?
    session[:requested_url] = request.fullpath
  end

  def session_expired?
    session[:renewed_at].nil? || session[:renewed_at] + SESSION_TIME.minutes < Time.now
  end

  def update_session
    session[:renewed_at] = Time.now
  end

  def redirect_after_login
    update_session
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

  def client_ip
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
  end
end

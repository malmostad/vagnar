class ApplicationController < ActionController::Base
  include Catchable

  protect_from_forgery with: :exception

  before_action :authenticate
  load_and_authorize_resource
  check_authorization

  before_action { add_body_class("#{controller_name} #{action_name}") }
  before_action :init_body_class

  SESSION_TIME = APP_CONFIG['session_time']

  def current_user
    @current_user ||= User.find(session[:user_id])
  rescue
    User.new(role: 'guest')
  end

  helper_method :current_user

  def authenticate
    if !current_user || session_expired?
      unless request.xhr?
        # Remember where the user was about to go
        session[:requested_url] = request.fullpath
      end
      flash.now[:warning] = "Du har varit inaktiv i #{SESSION_TIME} minuter och har loggats ut" if session_expired?
      redirect_to login_path
    end
    update_session
  end

  def session_expired?
    return true if session[:expires_at].nil? || session[:expires_at] < Time.now
  end

  def update_session
    session[:expires_at] = Time.now + SESSION_TIME.minutes
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
    add_body_class('seller') if current_user.present?
  end

  # Adds classnames to the body tag
  def add_body_class(name)
    @body_classes ||= ''
    @body_classes << "#{name} "
  end

  def reset_body_classes
    @body_classes = nil
    init_body_class
  end

  def client_ip
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
  end
end

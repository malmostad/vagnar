class ApplicationController < ActionController::Base
  # TODO: Ability
  # before_action :authenticate_seller
  # load_and_authorize_resource
  # check_authorization

  before_action { add_body_class("#{controller_name} #{action_name}") }
  before_action :init_body_class

  protect_from_forgery with: :exception

  SESSION_TIME = APP_CONFIG['session_time']

  def current_seller
    @current_seller ||= Seller.find(session[:seller_id])
  rescue
    false
  end
  helper_method :current_seller

  def authentic_seller
    if !current_seller || session_expired?
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
    add_body_class('seller') if current_seller.present?
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

  rescue_from CanCan::AccessDenied do |exception|
    logger.info "#{exception.message}"
    redirect_to root_path, alert: 'Behörighet saknas'
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    logger.debug { "#{exception.message}" }
    logger.info "ActionController::InvalidAuthenticityToken (maybe session expired) for the user from #{client_ip}"
    redirect_to logout_path, notice: 'Du är utloggad'
  end

  rescue_from ActiveRecord::RecordNotFound,
              ActionController::RoutingError,
              ActionController::UnknownController,
              ActionController::MethodNotAllowed do |exception|
    logger.info "#{exception.message}"
    logger.info "Not found: #{request.fullpath}"
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: 404 }
      format.all  { render nothing: true, status: 404 }
    end
  end
end

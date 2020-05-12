class ApplicationController < ActionController::Base
  include Catchable

  protect_from_forgery with: :exception
  before_action { add_body_class("#{controller_name} #{action_name}") }
  before_action :init_body_class

  before_action :authenticate_admin # skip in seller and public controllers

  SESSION_TIME = APP_CONFIG['session_time']

  def current_seller
    @current_seller ||= Seller.find(session[:seller_id]) if session[:seller_id]
  end
  helper_method :current_seller

  def authenticate_seller
    if current_seller && session_fresh?
      # Don't allow anything if the sellers company dosn't have an active permit
      if !current_seller.company.active_permit?
        redirect_to root_path, alert: "#{current_seller.company.name} har inget aktivt försäljningstillstånd"
      else
        update_session
        return true
      end
    else
      remember_requested_url
      redirect_to saml_login_path
    end
  end

  def current_admin
    @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end
  helper_method :current_admin

  def authenticate_admin
    if current_admin && session_fresh?
      update_session
      return true
    end

    remember_requested_url
    redirect_to administrera_path
  end

  def reset_session_keys
    reset_session
    session[:renewed_at] = nil
    session[:seller_id]  = nil
    session[:admin_id]   = nil
  end

  def session_fresh?
    session[:renewed_at] && session[:renewed_at].to_time > Time.now - SESSION_TIME.minutes
  end

  def update_session
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
    add_body_class('admin') if current_admin.present?
    add_body_class('seller') if current_seller.present?
  end

  # Adds classnames to the body tag
  def add_body_class(name)
    @body_classes ||= ''
    @body_classes << "#{name} "
  end
end

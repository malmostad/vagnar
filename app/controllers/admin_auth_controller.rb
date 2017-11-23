# Using LDAP authentication and authorizion
class AdminAuthController < ApplicationController
  skip_before_action :authenticate_admin
  skip_before_action :verify_authenticity_token

  layout 'login'

  def new
    @admin = Admin.new
  end

  def create
    reset_session_keys

    return stub_auth if APP_CONFIG['stub_auth']

    username = params[:username].strip.downcase
    @ldap = LdapAuth.new

    if !@ldap.authenticate(username, params[:password])
      @error_message = 'Fel användarnamn eller lösenord. Vänligen försök igen.'
      render :new

    elsif !@ldap.belongs_to_group?
      @error_message = 'Du saknar behörighet till systemet'
      render :new

    else
      admin = @ldap.update_admin_profile(username)
      if admin
        session[:admin_id] = admin.id
        update_session
        redirect_after_login
      else
        @error_message = 'Kunde inte spara användarinformationen'
        render :new
      end
    end
  end

  def destroy
    reset_session_keys
    redirect_to root_path, notice: 'Du är utloggad'
  end

  # Stubbed auth for local dev env
  # A user with the role admin has to exist first
  def stub_auth
    unless Rails.application.config.consider_all_requests_local
      redirect_to root_path, alert: 'Stubbed authentication only available in local environment'
    end

    admin = Admin.where(username: params[:username].strip.downcase).first
    if admin.save
      session[:admin_id] = admin.id
      update_session
      redirect_after_login
    else

      @error_message = "Användaren #{params[:username]} finns inte"
      render :new
    end
  end
end

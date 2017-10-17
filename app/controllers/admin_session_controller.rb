class AdminSessionController < ApplicationController
  layout 'login'

  def new
    reset_session
  end

  def create
    return stub_auth if APP_CONFIG['stub_auth']

    @ldap = LdapAuth.new

    unless @ldap.authenticate(params[:username], params[:password])
      @error_message = 'Fel användarnamn eller lösenord. Vänligen försök igen'
      render 'new' && return
    end

    unless @ldap.belongs_to_group?
      @error_message = 'Du saknar behörighet till systemet'
      render 'new' && return
    end

    user = @ldap.update_user_profile(username, role)
    if user
      session[:user_id] = user.id
      redirect_after_login && return
    end

    @error_message = 'Kunde inte spara användarinformationen'
    render 'new'
  end

  def destroy
    reset_session
    session[:expires_at] = nil
    session[:user_id]    = nil
    redirect_to root_path, notice: 'Du är utloggad'
  end

  # Stubbed auth for local dev env
  # User needs to exist in the db first
  def stub_auth
    unless Rails.application.config.consider_all_requests_local
      @error_message = 'Stubbed authentication only available in local environment'
      return render 'new'
    end

    admin = User.where(username: params[:username].strip.downcase, role: 'admin').first
    if admin
      session[:user_id] = admin.id
      logger.debug { "Stubbed authenticated admin #{current_user.id}" }
      redirect_after_login && return
    end

    @error_message = 'Användarnamnet finns inte'
    render 'new'
  end
end

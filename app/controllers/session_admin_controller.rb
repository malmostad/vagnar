class SessionAdminController < ApplicationController
  layout 'login'

  def new
  end

  def create
    stub_auth if APP_CONFIG['stub_auth']
  end

  # In dev env if the LDAP is not available
  # User needs to exist in the db first
  def stub_auth
    logger.debug '=' * 60
    if !Rails.application.config.consider_all_requests_local
      @error_message = 'Stubbed authentication only available in local environment'
      render 'new'
    else
      admin = User.where(username: params[:username].strip.downcase, role: 'admin').first

      if admin
        session[:user_id] = admin.id
        logger.debug { "Stubbed authenticated admin #{current_user.id}" }
        redirect_to '/'
      else
        @error_message = 'Användarnamnet finns inte'
        render 'new'
      end
    end
  end
end

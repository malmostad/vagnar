class SessionAdminController < ApplicationController
  layout 'login'

  def new
  end

  def create
    if APP_CONFIG['auth_method'] == 'stub' # Stubbed authentication for dev
      stub_auth
    end
  end

  # In dev env if the LDAP is not available
  # User needs to exist in the db first
  def stub_auth
    if !Rails.application.config.consider_all_requests_local
      @error_message = 'Stubbed authentication only available in local environment'
      render 'new'
    else
      admin = ADmin.where(username: params[:username].strip.downcase).first
      if admin
        session[:admin_id] = admin.id
        logger.debug { "Stubbed authenticated admin #{current_admin.id}" }
        redirect_after_login
      else
        @error_message = "Användarnamnet finns inte"
        render 'new'
      end
    end
  end
end

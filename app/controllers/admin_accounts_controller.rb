class AdminAccountsController < ApplicationController
  skip_authorize_resource
  skip_authorization_check

  before_action :authenticate_admin

  def index
    @admins = AdminAccount.order(:last_login_at)
  end
end

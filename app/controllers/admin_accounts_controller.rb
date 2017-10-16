class AdminAccountsController < ApplicationController
  def index
    @admins = AdminAccount.order(:last_login_at)
  end
end

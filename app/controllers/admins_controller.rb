class AdminsController < ApplicationController
  def index
    @admins = Admin.order(:last_login_at)
  end
end

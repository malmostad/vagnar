class AdminsController < ApplicationController
  before_action :authenticate_admin

  def index
    @admins = Admin.order(:username)
  end
end

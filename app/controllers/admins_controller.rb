class AdminsController < ApplicationController
  def index
    @admins = Admin.order(:username)
  end
end

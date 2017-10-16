class AdminAccountsController < ApplicationController
  before_action :authenticate_admin

  def index
    @admins = User.where(role: 'admin').order(:username)
  end
end

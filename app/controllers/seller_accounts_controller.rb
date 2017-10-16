class SellerAccountsController < ApplicationController
  before_action :authenticate

  def index
    @sellers = User.where(role: 'seller').order(:username)
  end
end

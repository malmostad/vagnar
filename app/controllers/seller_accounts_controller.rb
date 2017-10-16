class SellerAccountsController < ApplicationController
  def index
    @sellers = SellerAccounts.order(:username)
  end
end

class SellersController < ApplicationController
  def index
    @sellers = Seller.order(:p_number)
  end
end

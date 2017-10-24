class SellersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_seller, only: [:edit, :update, :destroy]

  def index
    @sellers = Seller.all.order(:ssn)
  end

  def show
  end

  def new
    @seller = Seller.new
  end

  def edit
  end

  def create
    @seller = Seller.new(seller_params)

    if @seller.save
      redirect_to sellers_path, notice: 'Försäljaren skapades'
    else
      render :new
    end
  end

  def update
    if @seller.update(seller_params)
      redirect_to sellers_path, notice: 'Försäljaren uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @seller.destroy
    redirect_to sellers_path, notice: 'Försäljaren togs bort'
  end

  private
    def set_seller
      @seller = Seller.find(params[:id])
    end

    def seller_params
      params.require(:seller).permit(:ssn, :name, :company)
    end
end

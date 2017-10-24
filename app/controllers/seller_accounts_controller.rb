class SellerAccountsController < ApplicationController
  before_action :authenticate_admin

  def index
    @seller_accounts = SellerAccount.all
  end

  def show
  end

  def new
    @seller_account = User.new(role: 'seller', seller_account: SellerAccount.new)
  end

  def edit
    @seller_account = User.where(role: 'seller', id: params[:id]).first
  end

  def create
    @seller_account = User.new(seller_account_params.merge(role: 'seller'))

    if @seller_account.save
      redirect_to seller_accounts_path, notice: 'Försäljaren skapades'
    else
      render :new
    end
  end

  def update
    @seller_account = User.where(role: 'seller', id: params[:id]).first

    if @seller_account.update(seller_account_params.merge(role: 'seller'))
      redirect_to seller_accounts_path, notice: 'Försäljaren uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @seller_account = SellerAccount.where(user_id: params[:id]).first
    @seller_account.user.destroy
    redirect_to seller_accounts_path, notice: 'Försäljaren togs bort'
  end

  private
    # Only allow a trusted parameter "white list" through.
    def seller_account_params
      params.require(:user).permit(:username)
    end
end

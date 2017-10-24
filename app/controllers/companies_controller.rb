class CompaniesController < ApplicationController
  before_action :authenticate_admin
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    @companies = Company.all.order(:name)
  end

  def show
  end

  def new
    @company = Company.new
  end

  def edit
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to companies_path, notice: 'Företaget skapades'
    else
      render :new
    end
  end

  def update
    if @company.update(company_params)
      redirect_to companies_path, notice: 'Företaget uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_path, notice: 'Företaget togs bort'
  end

  private
    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name)
    end
end

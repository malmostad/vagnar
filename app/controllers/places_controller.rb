class PlacesController < ApplicationController
  before_action :authenticate_admin
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  def index
    @places = Place.all
  end

  def show
  end

  def new
    @place = Place.new
  end

  def edit
  end

  def create
    @place = Place.new(place_params)

    if @place.save
      redirect_to @place, notice: 'Place was successfully created.'
    else
      render :new
    end
  end

  def update
    if @place.update(place_params)
      redirect_to @place, notice: 'Place was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @place.destroy
    redirect_to places_url, notice: 'Place was successfully destroyed.'
  end

  private
    def set_place
      @place = Place.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def place_params
      params.require(:place).permit(:place, :name)
    end
end

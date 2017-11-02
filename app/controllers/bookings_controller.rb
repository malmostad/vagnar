class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  def index
    @bookings = Booking.all
  end

  def show
  end

  def new
    @booking = Booking.new
    @companies_with_permit = Company.with_active_permit
    @active_places = Place.where(active: true).order(:name)
  end

  def edit
    @active_places = Place.where(active: true).order(:name)
  end

  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      redirect_to bookings_path, notice: 'Bokningen skapades'
    else
      render :new
    end
  end

  def update
    if @booking.update(booking_params)
      redirect_to bookings_path, notice: 'Bokningen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_path, notice: 'Bokningen togs bort'
  end

  private
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def booking_params
      params.require(:booking).permit(:company_id, :place_id, :date, :time_slot_id)
    end
end

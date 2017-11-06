class BookingsController < ApplicationController
  before_action :set_relations, only: [:new, :update]

  def index
    @bookings = Booking.includes(:place, :time_slot, :company).present
    @booking_period = BookingPeriod.current
  end

  def archive
    @bookings = Booking.past
  end

  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      redirect_to bookings_path, notice: 'Bokningen skapades'
    else
      render :new
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bookings_path, notice: 'Bokningen togs bort'
  end

  private
    def set_relations
      @companies_with_permit = Company.with_active_permit.order(:name)
      @active_places = Place.where(active: true).order(:name)
      # TODO: get as param
      @booking_period = BookingPeriod.first
    end

    # Only allow a trusted parameter "white list" through.
    def booking_params
      params.require(:booking).permit(:company_id, :place_id, :date, :time_slot_id, :booking_period_id)
    end
end

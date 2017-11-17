class BookingsController < ApplicationController
  before_action :set_relations, only: [:new, :update]

  def index
    @bookings = Booking.includes(:place, :time_slot, :company).present.order(:date, 'time_slots.from', 'places.name')
    @bookable_periods = BookingPeriod.includes(bookings: [:place, :time_slot, :company]).bookables
  end

  def archive
    @bookings = Booking.past.booked
  end

  def edit
    @booking = Booking.find(params[:id])
    @companies_with_permit = Company.with_active_permit
  end

  def update
    @booking = Booking.find(params[:id])

    if @booking.update(booking_params)
      redirect_to bookings_path, notice: 'Bokningen genomfördes'
    else
      render :edit
    end
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
    company = @booking.company
    @booking.destroy
    if params[:from_company_view]
      redirect_to company_path(company), notice: 'Bokningen togs bort'
    else
      redirect_to bookings_path, notice: 'Bokningen togs bort'
    end
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

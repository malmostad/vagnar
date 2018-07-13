class BookingsController < ApplicationController
  def index
    @bookings = Booking.bookables.includes(:place, :time_slot, :company).present.order(:date, 'time_slots.from', 'places.name')
    @bookable_periods = BookingPeriod.includes(bookings: [:place, :time_slot, :company]).bookables
  end

  def archive
    @bookings = Booking.past.booked
  end

  def edit
    @booking = Booking.find(params[:id])
    @companies_with_permit = Company.with_active_permit.order(:name)
  end

  def update
    @booking = Booking.find(params[:id])

    if @booking.company.present?
      redirect_to bookings_path, alert: 'Platsen och tiden är redan bokad'
    elsif !@booking.bookable?
      redirect_to bookings_path, alert: 'Bokningen är inte i en aktiv bokningsperiod'
    elsif @booking.update(booking_params)
      redirect_to bookings_path, notice: 'Bokningen genomfördes'
    else
      render :edit
    end
  end

  def cancel
    @booking = Booking.find(params[:id])

    @booking.company = nil
    @booking.save
    redirect_to bookings_path, notice: 'Avbokning genomförd'
  end

  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      redirect_to bookings_path, notice: 'Bokningen skapades'
    else
      render :new
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def booking_params
      params.require(:booking).permit(:company_id, :place_id, :date, :time_slot_id, :booking_period_id)
    end
end

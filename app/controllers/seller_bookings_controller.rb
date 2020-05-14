class SellerBookingsController < ApplicationController
  skip_before_action :authenticate_admin
  before_action :authenticate_seller
  before_action :set_booking

  def index
    @bookings = current_seller.company.bookings&.present

    respond_to do |format|
      format.html
      format.xlsx {
        send_data Sheet.for_bookings(@bookings),
          type: :xlsx,
          disposition: 'attachment',
          filename: "bokningar_utskriven_#{Date.today.iso8601}.xlsx"
      }
    end
  end

  def schedule
    @bookings = Booking.bookables.includes(:place, :time_slot, :company).order(:date, 'time_slots.from', 'places.name')
    @dates = @bookings.map(&:date).uniq
    @places = Place.all
    @time_slots = TimeSlot.all
    @bookable_periods = BookingPeriod.bookables
  end

  def update
    @booking = Booking.find(params[:id])

    if current_seller.company.reached_booking_limit?
      redirect_to seller_bookings_schedule_path, alert: @limit_reached_msg

    elsif @booking.company.present?
      redirect_to schedule_seller_bookings_path, alert: 'Platsen och tiden är redan bokad'

    elsif !@booking.bookable?
      redirect_to schedule_seller_bookings_path, alert: 'Bokningen är inte i en aktiv bokningsperiod'

    elsif @company.day_and_timeslot_booked?(@booking)
      redirect_to schedule_seller_bookings_path, alert: @day_and_timeslot_booked_msg

    else
      @booking.company = @company
      @booking.save
      redirect_to schedule_seller_bookings_path, notice: 'Bokningen genomfördes'
    end
  end

  def cancel
    @booking = Booking.find(params[:id])

    if @booking.company != @company
      redirect_to schedule_seller_bookings_path, alert: 'Du kan endast avbokna era egna bokningar'
    else
      @booking.company = nil
      @booking.save
      redirect_to seller_bookings_path, notice: 'Avbokning genomförd'
    end
  end

  private

  def set_booking
    @limit_reached_msg = "Max antal samtidiga bokingar är #{Setting.where(key: :number_of_bookings).first.value.to_i} Avboka först.".freeze
    @day_and_timeslot_booked_msg = 'Endast en plats kan bokas på samma dag och tid'
    @company = current_seller.company
  end

  def seller_booking_params
    params.require(:booking).permit(:company_id)
  end
end

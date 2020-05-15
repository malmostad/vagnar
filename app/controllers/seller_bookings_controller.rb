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

    if not_allowed
      redirect_to schedule_seller_bookings_path, alert: not_allowed
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

  def not_allowed
    return 'Bokningen är inte i en aktiv bokningsperiod' unless @booking.bookable?
    return 'Platsen och tiden är redan bokad' if @booking.company.present?
    return @limit_reached_msg if current_seller.company.reached_booking_limit?
    return @day_and_timeslot_booked_msg if @company.day_and_timeslot_booked?(@booking)
    return @reached_place_limit_msg if @company.reached_place_limit?(@booking)
  end

  def set_booking
    @limit_reached_msg = "Max #{
      Setting.where(key: :number_of_bookings).first.value.to_i
    } bokingar kan göras inom en bokningsperiod".freeze

    @day_and_timeslot_booked_msg = 'Endast 1 plats kan bokas på samma dag och tid'

    @reached_place_limit_msg = "En plats kan endast bokas #{
      Setting.where(key: :max_bookings_of_place).first.value.to_i
    } gånger inom en bokningsperiod".freeze

    @company = current_seller.company
  end

  def seller_booking_params
    params.require(:booking).permit(:company_id)
  end
end

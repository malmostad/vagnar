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
          disposition: "attachment",
          filename: "bokningar_utskriven_#{Date.today.iso8601}.xlsx"
      }
    end
  end

  def schedule
    @bookings = Booking.includes(:place, :time_slot, :company).present.order(:date, 'time_slots.from', 'places.name')
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

    else
      @booking.company = @company
      @booking.save
      redirect_to schedule_seller_bookings_path, notice: 'Bokningen genomfördes'
    end
  end

  def destroy
    @booking = Booking.find(params[:id])

    if current_seller.allowed_to_manage_booking(@booking)
      @booking.destroy
      redirect_to seller_bookings_path, notice: 'Bokningen togs bort'
    else
      redirect_to seller_bookings_path, alert: 'Du har inte rättighet att ta bort bokningen'
    end
  end

  private
    def set_booking
      @limit_reached_msg = "Max antal samtidiga bokingar är #{Setting.where(key: :number_of_bookings).first.value.to_i} Avboka först.".freeze
      @company = current_seller.company
    end

    def seller_booking_params
      params.require(:booking).permit(:place_id, :date, :time_slot_id, :booking_period_id)
    end
end

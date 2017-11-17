class SellerBookingsController < ApplicationController
  skip_before_action :authenticate_admin
  before_action :authenticate_seller
  before_action :set_booking

  def index
    @bookings = current_seller.company.bookings&.present
  end

  def schedule
    @bookings = Booking.includes(:place, :time_slot, :company).present.order(:date, 'time_slots.from', 'places.name')
    @bookable_periods = BookingPeriod.includes(bookings: [:place, :time_slot, :company]).bookables
  end

  # TODO: check that company dosn't have too many bookings. ALSO in other views
  # "Books" a free booking, i.e. assigns it to company
  def update
    @booking = Booking.find(params[:id])

    if current_seller.company.reached_booking_limit?
      redirect_to seller_bookings_schedule_path, warning: @limit_reached_msg

    elsif @booking.company.present?
      redirect_to seller_bookings_schedule_path, warning: 'Platsen och tiden är redan bokad'

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

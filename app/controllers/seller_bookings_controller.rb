class SellerBookingsController < ApplicationController
  skip_before_action :authenticate_admin
  before_action :authenticate_seller

  def index
    @bookings = current_seller.company.bookings&.present
  end

  def schedule
    @bookings = Booking.includes(:place, :time_slot, :company).booked.present.order(:date, 'time_slots.from', 'places.name')
    @bookable_periods = BookingPeriod.includes(bookings: [:place, :time_slot, :company]).bookables
  end

  # TODO: check that company dosn't have too many bookings. ALSO in other views
  # "Books" a free booking, i.e. assigns it to company
  def update
    @booking = Booking.find(params[:id])
    if @booking.company.present?
      redirect_to seller_bookings_schedule_path, warning: 'Platsen och tiden är redan bokad'
    else
      @booking.company = current_seller.company
      @booking.save
      redirect_to seller_bookings_path, notice: 'Bokningen genomfördes'
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
    def seller_booking_params
      params.require(:booking).permit(:place_id, :date, :time_slot_id, :booking_period_id)
    end
end

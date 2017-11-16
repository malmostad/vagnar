class SellerBookingsController < ApplicationController
  skip_before_action :authenticate_admin
  before_action :authenticate_seller

  def index
    @bookings = current_seller.company.bookings&.present
  end

  def new
    @current_periods = BookingPeriod.currents
    @bookable_periods = BookingPeriod.bookables
  end

  def create
    if !current_seller.company.active_permit?
      redirect_to seller_bookings_path, notice: "#{current_seller.company.name} har för närvarande inget aktivt försäljningstillstånd"
    else
      @booking = Booking.new(seller_booking_params.merge(company: current_seller.company))
      @booking.save
      redirect_to seller_bookings_path, notice: 'Din bokningen skapades'
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

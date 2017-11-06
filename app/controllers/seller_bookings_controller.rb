class SellerBookingsController < ApplicationController
  skip_before_action :authenticate_admin
  before_action :authenticate_seller

  before_action :set_relations, only: [:new, :edit, :update]

  def index
    @present_bookings = current_seller.present_bookings
    @booking_period = BookingPeriod.current
  end

  def new
    @booking = Booking.new
  end

  def create
    # Set company expicit
    @booking = Booking.new(seller_booking_params.merge(company: current_seller.company))

    if @booking.save
      redirect_to seller_bookings_path, notice: 'Din bokningen skapades'
    else
      render :new
    end
  end

  def destroy
    @booking = Booking.find(params[:id])

    if current_seller.allowed_to_manage_booking(@booking)
      @booking.destroy
      redirect_to seller_bookings_path, notice: 'Bokningen togs bort'
    else
      redirect_to seller_bookings_path, notice: 'Du har inte rättighet att ta bort bokningen'
    end
  end

  private
    def seller_booking_params
      params.require(:booking).permit(:place_id, :date, :time_slot_id, :booking_period_id)
    end
end

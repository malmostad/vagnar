class HomeController < ApplicationController
  skip_before_action :authenticate_admin

  def index
    @bookings = BookingPeriod.current.bookings.booked.present
                             .includes(:time_slot, :place)
                             .order(:date, 'time_slots.from', 'places.name')
  end
end

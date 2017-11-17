class HomeController < ApplicationController
  skip_before_action :authenticate_admin

  def index
    @bookings = Booking
                .includes(:time_slot, :place)
                .present
                .booked
                .order('date', 'time_slots.from', 'places.name')
  end
end

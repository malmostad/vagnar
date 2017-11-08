class HomeController < ApplicationController
  skip_before_action :authenticate_admin

  def index
    @bookings = BookingPeriod.current.first&.bookings
  end
end

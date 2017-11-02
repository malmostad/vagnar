class BookingPeriod < ApplicationRecord
  has_many :bookings

  validates_presence_of :starts_at, :ends_at, :booking_starts_at, :booking_ends_at

  # Don't allow destruction, bookings are used for archive listings
  before_destroy do
    raise 'Destroy is not allowed for booking periods'
  end
end

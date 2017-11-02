class BookingPeriod < ApplicationRecord
  has_many :bookings, dependent: :nullify

  validates_presence_of :starts_at, :ends_at, :booking_starts_at, :booking_ends_at
end

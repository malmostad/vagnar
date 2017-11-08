class BookingPeriod < ApplicationRecord
  has_many :bookings, dependent: :nullify

  validates_presence_of :starts_at, :ends_at, :booking_starts_at, :booking_ends_at

  scope :current, -> do
    where('starts_at <= ?', Date.today)
      .where('ends_at >= ?', Date.today)
  end

  scope :bookable, -> do
    where('booking_starts_at <= ?', Date.today)
      .where('booking_ends_at >= ?', Date.today)
  end
end

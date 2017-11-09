class BookingPeriod < ApplicationRecord
  has_many :bookings, dependent: :nullify

  validates_presence_of :starts_at,
                        :ends_at,
                        :booking_starts_at,
                        :booking_ends_at

  scope :current, -> do
    where('starts_at <= ?', Date.today)
      .where('ends_at >= ?', Date.today)
      .first
  end

  scope :bookable, -> do
    where('booking_starts_at <= ?', Date.today)
      .where('booking_ends_at >= ?', Date.today)
      .first
  end

  def booking_time_starts_at
    booking_starts_at&.to_s(:time)
  end

  def booking_time_ends_at
    booking_ends_at&.to_s(:time)
  end

  def booking_date_starts_at
    booking_starts_at&.to_date.to_s
  end

  def booking_date_ends_at
    booking_ends_at&.to_date.to_s
  end
end

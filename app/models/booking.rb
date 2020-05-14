class Booking < ApplicationRecord
  belongs_to :place
  belongs_to :company, optional: true
  belongs_to :time_slot
  belongs_to :booking_period

  validates_presence_of :place, :date, :time_slot

  scope :free, -> { where(company: nil) }
  scope :booked, -> { where.not(company: nil) }

  # TODO: change name to 'current' for consistency
  scope :present, -> { where('date >= ?', Date.today).where.not(booking_period: nil) }
  scope :past, -> { where('date < ?', Date.today) }

  scope :bookables, -> {
    present.joins(:booking_period).where('booking_periods.booking_starts_at <= ? and booking_periods.booking_ends_at >= ?', DateTime.now, DateTime.now)
  }

  # Only allow destruction in current booking period
  # Past bookings are used for archive listings
  before_destroy do
    raise 'Destroy is not allowed for active bookings' unless current?
  end

  before_update do
    raise 'Edit past bookings is not allowed' if past?
  end

  def free?
    company.nil?
  end

  def booked?
    company.present?
  end

  def bookable?
    date >= Date.today &&
        booking_period.booking_starts_at <= DateTime.now &&
        booking_period.booking_ends_at >= DateTime.now
  end

  def current?
    date >= Date.today
  end

  def past?
    date < Date.today
  end
end

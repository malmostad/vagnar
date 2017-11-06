class Booking < ApplicationRecord
  belongs_to :place
  belongs_to :company
  belongs_to :time_slot
  belongs_to :booking_period

  validates_presence_of :place, :company, :date, :time_slot

  scope :present, -> { where('date >= ?', Date.today) }
  scope :past, -> { where('date <= ?', Date.today) }

  # Only allow destruction in current booking period
  # Past bookings are used for archive listings
  before_destroy do
    raise 'Destroy is not allowed for active bookings' unless present?
  end

  def present?
    date >= Date.today
  end

  def past?
    date <= Date.today
  end

  def in_current_period?
    booking_period.current
  end
end

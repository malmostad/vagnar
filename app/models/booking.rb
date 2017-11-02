class Booking < ApplicationRecord
  belongs_to :place
  belongs_to :company
  belongs_to :time_slot
  belongs_to :booking_period

  validates_presence_of :place, :company, :date, :time_slot

  scope :present, -> { where('date >= ?', Date.today) }
  scope :past,    -> { where('date <= ?', Date.today) }

  # Don't allow destruction, bookings are used for archive listings
  before_destroy do
    raise 'Destroy is not allowed for bookings'
  end
end

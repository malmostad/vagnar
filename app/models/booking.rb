class Booking < ApplicationRecord
  belongs_to :place
  belongs_to :company
  belongs_to :time_slot
  belongs_to :booking_period

  validates_presence_of :place, :company, :date, :time_slot, :booking_period
end

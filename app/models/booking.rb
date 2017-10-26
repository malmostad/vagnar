class Booking < ApplicationRecord
  belongs_to :place
  belongs_to :company
  belongs_to :time_slot

  validates_presence_of :place, :company, :date
end

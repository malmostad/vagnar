class Booking < ApplicationRecord
  belongs_to :place
  belongs_to :company
  belongs_to :time_slot

  validates_presence_of :place
  validates_presence_of :company
end

class Booking < ApplicationRecord
  belongs_to :place
  belongs_to :seller

  validates_presence_of :place
end

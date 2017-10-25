# Bokningstider
class TimeSlot < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validates :from, :to, presence: true, format: { with: /\A\d\d\.\d\d\z/,
      message: "anges med formatet '08.00'" }
end

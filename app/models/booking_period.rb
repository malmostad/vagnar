class BookingPeriod < ApplicationRecord
  has_many :bookings, dependent: :nullify

  validates_presence_of :starts_at, :ends_at, :booking_starts_at, :booking_ends_at

  scope :current, -> { first } # TODO: calculate

  before_create :create_bookings

  private

  def create_bookings
    starts_at.upto(ends_at).each do |date|
      TimeSlot.all.each do |time_slot|
        Place.where(active: true).each do |place|
          bookings.new(
            place: place,
            time_slot: time_slot,
            date: date
          )
        end
      end
    end
  end
end

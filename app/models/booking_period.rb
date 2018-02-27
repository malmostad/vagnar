class BookingPeriod < ApplicationRecord
  has_many :bookings, dependent: :nullify

  validates_presence_of :starts_at,
                        :ends_at,
                        :booking_starts_at,
                        :booking_ends_at
  scope :currents, -> {
    where('ends_at >= ?', Date.today)
  }

  scope :bookables, -> {
    where('booking_starts_at <= ? and booking_ends_at >= ?', DateTime.now, DateTime.now)
  }

  before_create :create_bookings

  def bookable?
    booking_starts_at <= DateTime.now && booking_ends_at >= DateTime.now
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

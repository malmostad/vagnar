class Company < ApplicationRecord
  has_many :sellers, dependent: :destroy
  has_many :bookings, dependent: :destroy

  validates_presence_of :name, :org_number

  # Don't allow destruction, bookings and companies are used for archive listings
  before_destroy do
    raise 'Destroy is not allowed for companies'
  end

  scope :with_active_permit, lambda {
    where('permit_starts_at <= ? and permit_ends_at >= ?', Date.today, Date.today)
  }

  def reached_booking_limit?
    present_bookings.size >= Setting.where(key: :number_of_bookings).first.value.to_i
  end

  def present_bookings
    Booking.present.where(company: self)
  end

  def day_and_timeslot_booked?(booking)
    present_bookings.where(time_slot: booking.time_slot, date: booking.date).present?
  end

  def active_permit?
    permit_starts_at.present? && permit_ends_at.present? &&
        permit_starts_at <= Date.today && permit_ends_at >= Date.today
  end
end

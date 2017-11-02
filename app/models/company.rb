class Company < ApplicationRecord
  has_many :sellers, dependent: :destroy
  has_many :bookings, dependent: :destroy

  validates_presence_of :name, :org_number

  scope :with_active_permit, lambda {
    where('permit_starts_at <= ? and permit_ends_at >= ?', Date.today, Date.today)
  }

  def active_permit?
    permit_starts_at <= Date.today && permit_ends_at >= Date.today
  end
end

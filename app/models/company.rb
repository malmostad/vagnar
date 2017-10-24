class Company < ApplicationRecord
  has_many :sellers, dependent: :destroy
  has_many :bookings, dependent: :destroy
end

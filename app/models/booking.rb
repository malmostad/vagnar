class Booking < ApplicationRecord
  belongs_to :place
  belongs_to :seller_account, via: :user

  validates_presence_of :place
end

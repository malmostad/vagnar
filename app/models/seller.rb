class Seller < ApplicationRecord
  validates_uniqueness_of :p_number
  validates_presence_of   :p_number
end

class Seller < ApplicationRecord
  validates_presence_of :ssn
  validates_uniqueness_of :ssn
  validates_presence_of :name
  validates_presence_of :company
end

class Seller < ApplicationRecord
  belongs_to :company

  validates :snin,
            presence: true,
            uniqueness:   true
  validates_presence_of :company

  before_create do
    s = Snin.new(snin)
    self.snin = s.plain
    errors.add(:snin, "Kontrollsiffran stämmer inte") unless s.valid?
  end
end

class Seller < ApplicationRecord
  belongs_to :company

  validates :snin,
            presence: true,
            uniqueness:   true
  validates_presence_of :company

  validate :valid_snin, on: :create

  before_validation do
    self.last_login_at = Time.now
  end

  def valid_snin
    s = Snin.new(snin)
    self.snin = s.plain
    errors.add(:snin, 'Kontrollsiffran stämmer inte') unless s.valid?
  end

  def formatted_snin
    s = Snin.new(snin)
    s.add_dash(s.plain)
  end
end

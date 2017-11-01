class Seller < ApplicationRecord
  belongs_to :company

  validates_presence_of :name, :company
  validates :name, presence: true
  validates :snin_birthdate, format: { with: /\A\d{8}\z/ }
  validates :snin_extension, format: { with: /\A\d{4}\z/ }
  validate :valid_snin, on: :create

  before_validation do
    self.last_login_at = Time.now
  end

  before_save :hash_snin_extension

  private

  def hash_snin_extension
    self.snin_extension = Digest::SHA512.hexdigest(snin_extension + Rails.application.secrets.secret_key_base)
  end

  def valid_snin
    s = Snin.new(snin_birthdate.to_s + snin_extension.to_s)
    self.snin_birthdate = s.to_date.to_s
    errors.add(:snin_extension, 'Kontrollsiffran stämmer inte') unless s.valid?
  end
end

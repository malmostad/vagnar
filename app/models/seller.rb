class Seller < ApplicationRecord
  belongs_to :company

  validates_presence_of :company
  validates_presence_of :name, on: :create
  validate              :valid_snin, on: :create
  validate              :unique_snin, on: :create

  before_validation do
    self.last_login_at = Time.now
  end

  before_create do
    self.snin_extension = snin_extension_hash
  end

  def snin_extension_hash
    Digest::SHA512.hexdigest(snin_extension + Rails.application.secrets.secret_key_base)
  end

  def self.where_snin(snin)
    snin = Snin.new(snin)
    where(snin_birthday: snin.birthday, snin_extension: hashit(snin.extension))
  end

  private

  def hashit(extension)
  end

  def valid_snin
    snin = Snin.new(snin_birthday.to_s + snin_extension.to_s)
    errors.add(:snin_extension, 'Kontrollsiffran stämmer inte') unless snin.valid?
  end

  def unique_snin
    new_seller = Seller.where(snin_birthday: snin_birthday, snin_extension: snin_extension_hash)
    errors.add(:snin_birthday, 'Personnummret finns redan') if new_seller.present?
  end
end

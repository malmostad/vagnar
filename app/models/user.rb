# Basic user account.
# A user has a seller_account or an admin_account.
class User < ApplicationRecord
  has_one :seller_account, dependent: :destroy
  has_one :admin_account, dependent: :destroy

  accepts_nested_attributes_for :seller_account, :admin_account
  validates_associated :seller_account, :admin_account

  validates_presence_of :username
  validates_uniqueness_of :username, case_sensitive: false

  validate do
    if role == 'admin'
      errors.add(:role, 'admin must have an admin account') unless admin_account.present?
    elsif role == 'seller'
      errors.add(:role, 'seller must have a seller account') unless seller_account.present?
    else
      errors.add(:role, 'doesn’t match account type admin or seller')
    end
  end

  # Check for one or more roles
  def has_role?(*check_roles)
    check_roles.map(&:to_s).include? role
  end
end

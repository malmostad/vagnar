class Admin < ApplicationRecord
  validates_presence_of :username
  validates_uniqueness_of :username

  before_save do
    self.last_login_at = Time.now
  end
end

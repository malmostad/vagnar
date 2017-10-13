class Admin < ApplicationRecord
  validates_presence_of :username
  validates_uniqueness_of :username, case_sensitive: false
end

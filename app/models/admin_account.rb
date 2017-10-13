class AdminAccount < ApplicationRecord
  belongs_to :user

  validates_presence_of :username
end

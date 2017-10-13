FactoryGirl.define do
  factory :admin do
    sequence(:username) { |n| "user-#{n}" }
  end
end

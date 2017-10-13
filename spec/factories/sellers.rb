FactoryGirl.define do
  factory :seller do
    sequence(:p_number) { |n| "190101-000#{n}" }
    sequence(:name) { |n| "user-#{n}" }
    email "barista#{n}@example.com"
    company_name "Baristorna #{n} AB"
  end
end

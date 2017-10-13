# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.first_or_create(
  username: 'admin-1',
  last_login_at: Time.now,
  ip: '127.0.0.2'
)
Seller.first_or_create(
  p_number: '190001010000',
  name: 'Barista Baristasson',
  email: 'barista@example.com',
  company_name: 'Baristorna ☕️ AB',
  last_login_at: Time.now,
  ip: '127.0.0.3'
)

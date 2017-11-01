Admin.create(username: 'intra')

['Baristorna AB', 'Små smoothisar AB'].each do |name|
  Company.create(name: name)
end

Seller.create(
  snin_birthday: '19000101',
  snin_extension: '0008',
  name: 'Barista Baristasson',
  company: Company.find(1),
  last_login_at: Time.now
)

Seller.create(
  snin_birthday: '19000102',
  snin_extension: '0007',
  name: 'Malin Macchiato',
  company: Company.find(1),
  last_login_at: 1.day.ago
)

Seller.create(
  snin_birthday: '19000103',
  snin_extension: '0006',
  name: 'Smooth Smoothsson',
  company: Company.find(2),
  last_login_at: 2.days.ago
)

Place.create(name: 'Kaffeplatsen', address: 'August Palms plats 1')
Place.create(name: 'Smoothiehörnan', address: 'Storgatan 1')

[
  { from: '06.00', to: '10.00' },
  { from: '10.00', to: '15.00' },
  { from: '15.00', to: '20.00' },
  { from: '20.00', to: '24.00' }
].each do |time_slot|
  TimeSlot.create(time_slot)
end

Booking.create(place: Place.find(1), company: Company.first, time_slot: TimeSlot.find(1), date: 1.week.from_now.to_date)
Booking.create(place: Place.find(1), company: Company.first, time_slot: TimeSlot.find(2), date: 2.week.from_now.to_date)
Booking.create(place: Place.find(2), company: Company.last, time_slot: TimeSlot.find(3), date: 3.week.from_now.to_date)
Booking.create(place: Place.find(2), company: Company.last, time_slot: TimeSlot.find(4), date: 4.week.from_now.to_date)

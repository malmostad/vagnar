Admin.create!(username: 'intra')

[
  { from: '06.00', to: '10.00' },
  { from: '10.00', to: '15.00' },
  { from: '15.00', to: '20.00' },
  { from: '20.00', to: '24.00' }
].each do |time_slot|
  TimeSlot.create!(time_slot)
end

Setting.create!(key: 'number_of_bookings', human_name: 'Max bokningar per aktör och bokningsperiod', value: 100)
Setting.create!(key: 'max_bookings_of_place', human_name: 'Max bokningar av samma plats under en bokningsperiod', value: '10')

Company.create!(
  name: 'Baristorna AB',
  org_number: '556677-8899',
  police_permit: '12345 d-34',
  permit_starts_at: 1.month.ago,
  permit_ends_at: 11.months.from_now
)

Company.create!(
  name: 'Små smoothisar AB',
  org_number: '551122-3344',
  police_permit: '987654 d-1',
  permit_starts_at: 13.months.ago,
  permit_ends_at: 1.months.ago
)

Seller.create!(
  snin_birthday: '19000101',
  snin_extension: '0008',
  name: 'Barista Baristasson',
  company: Company.find(1),
  last_login_at: Time.now
)

Seller.create!(
  snin_birthday: '19000102',
  snin_extension: '0007',
  name: 'Malin Macchiato',
  company: Company.find(1),
  last_login_at: 1.day.ago
)

Seller.create!(
  snin_birthday: '19000103',
  snin_extension: '0006',
  name: 'Smooth Smoothsson',
  company: Company.find(2),
  last_login_at: 2.days.ago
)

Place.create!(
  name: 'Kaffeplatsen',
  address: 'August Palms plats 1',
  east: 118_942,
  north: 6_163_918,
  active: true
)
Place.create!(
  name: 'Smoothiehörnan',
  address: 'Storgatan 1',
  east: 118_756,
  north: 6_164_142,
  active: true
)

BookingPeriod.create!(
  starts_at: Date.today - 2.days,
  ends_at:  Date.today + 2.weeks,
  booking_starts_at:  DateTime.now - 7.days,
  booking_ends_at:  DateTime.now + 1.week
)

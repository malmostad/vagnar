Admin.create(username: 'intra')

Seller.create(
  snin: '19000101-0008',
  name: 'Barista Baristasson',
  company: Company.create(name: 'Baristorna AB')
)

Seller.create(
  snin: '19990203-0007',
  name: 'Smooth Smoothsson',
  company: Company.create(name: 'Små smoothisar AB')
)

place = Place.create(name: 'Kaffeplatsen', address: 'August Palms plats 1')

[
  { from: '06.00', to: '10.00' },
  { from: '10.00', to: '15.00' },
  { from: '15.00', to: '20.00' },
  { from: '20.00', to: '24.00' },
  { from: '24.00', to: '04.00' }
].each do |time_slot|
  TimeSlot.create(time_slot)
end

Booking.create(place_id: place.id, company_id: Company.first.id, time_slot_id: TimeSlot.first.id)
Booking.create(place_id: place.id, company_id: Company.last.id, time_slot_id: TimeSlot.last.id)

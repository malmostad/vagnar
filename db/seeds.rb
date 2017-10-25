Admin.create(username: 'intra')

company = Company.create(name: 'Baristorna ☕️ AB')

Seller.create(
  snin: '19000101-0008',
  name: 'Barista Baristasson',
  company_id: company.id
)

place = Place.create(name: 'Kaffeplatsen')

[
  { from: '06.00', to: '10.00' },
  { from: '10.00', to: '15.00' },
  { from: '15.00', to: '20.00' },
  { from: '20.00', to: '24.00' },
  { from: '24.00', to: '04.00' }
].each do |time_slot|
  TimeSlot.create(time_slot)
end

Booking.create(place_id: place.id, company_id: company.id, time_slot_id: TimeSlot.first.id)

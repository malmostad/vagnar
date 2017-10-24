Admin.where(username: 'intra').first_or_create

seller = Seller.where(
  ssn: '19000101-0000',
  name: 'Barista Baristasson',
  company: 'Baristorna ☕️ AB'
).first_or_create

place = Place.where(name: 'Kaffeplatsen').first_or_create

Booking.where(place_id: place.id, seller_id: seller.id).first_or_create

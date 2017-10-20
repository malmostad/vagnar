User.where(username: '19000101-0000').destroy_all
seller = User.create(
  username: '19000101-0000',
  role: 'seller',
  last_login_at: Time.now,
  seller_account: SellerAccount.new(
    name: 'Barista Baristasson'
  )
)

User.where(username: 'intra').destroy_all
User.create(
  role: 'admin',
  username: 'intra',
  last_login_at: Time.now,
  admin_account: AdminAccount.new
)

Place.where(name: 'Kaffeplatsen').destroy_all
place = Place.create(
  name: 'Kaffeplatsen'
)

Booking.create(
  place_id: place.id,
  seller_account_id: seller.seller_account.id
)

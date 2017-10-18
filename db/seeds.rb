if User.count.zero?
  User.create(
    username: '19000101-0000',
    role: 'seller',
    last_login_at: Time.now,
    seller_account: SellerAccount.new(
      name: 'Barista Baristasson'
    )
  )

  User.create(
    role: 'admin',
    username: 'intra',
    last_login_at: Time.now,
    admin_account: AdminAccount.new(
    )
  )
end

if User.count.zero?
  User.create(
    role: 'seller',
    last_login_at: Time.now,
    ip_address: '127.0.0.1',
    seller_account: SellerAccount.new(
      username: '19000101-0000'
    )
  )

  User.create(
    role: 'admin',
    last_login_at: Time.now,
    ip_address: '127.0.0.2',
    admin_account: AdminAccount.new(
      username: 'intra12'
    )
  )
end

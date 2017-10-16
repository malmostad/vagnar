if User.count.zero?
  User.create(
    role: 'seller',
    last_login_at: Time.now,
    ip_address: '127.0.0.1',
    username: '19000101-0000',
    seller_account: SellerAccount.new(
    )
  )

  User.create(
    role: 'admin',
    username: 'intra12',
    last_login_at: Time.now,
    ip_address: '127.0.0.2',
    admin_account: AdminAccount.new(
    )
  )
end

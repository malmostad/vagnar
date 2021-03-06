class LdapAuth
  ATTRIBUTES = %w[cn].freeze

  def initialize
    @config = Rails.application.secrets.ldap

    @client = Net::LDAP.new(
      host: @config[:host],
      port: @config[:port],
      verbose: true,
      encryption: { method: :simple_tls },
      auth: {
        method: :simple,
        username: @config[:system_username],
        password: @config[:system_password]
      }
    )
  end

  def authenticate(username, password)
    @username = username.strip.downcase
    return false if @username.empty? || password.empty?

    bind_user = @client.bind_as(
      base: @config[:basedn],
      filter: "cn=#{@username}",
      password: password,
      attributes: ATTRIBUTES
    )

    # We need to check that cn is the same as @username
    # since the AD binds usernames with non-ascii chars
    if bind_user && bind_user&.first&.cn&.first&.downcase == @username
      Rails.logger.info "[LDAP_AUTH] #{@username} authenticated successfully. #{@client.get_operation_result}"
      return true
    end

    Rails.logger.info "[LDAP_AUTH] #{@username} failed to log in. #{@client.get_operation_result}"
    false
  end

  def belongs_to_group?
    @config[:roles].each do |group|
      # 1.2.840.113556.1.4.1941 is the MS AD way
      filter = (Net::LDAP::Filter.eq('cn', @username) &
        Net::LDAP::Filter.ex(
          'memberOf:1.2.840.113556.1.4.1941',
           "CN=#{group[:ldap_name]},#{@config[:base_group]}")
         )

      entry = @client.search(base: @config[:basedn], filter: filter).first
      return group[:name] if entry.present?
    end

    Rails.logger.info "[LDAP_AUTH] #{@username} failed to log in: doesn't belong to a group."
    false
  end

  # Update user attributes from the ldap user
  def update_admin_profile(username)
    begin
      username = username.strip.downcase
      # Find or create user
      admin               = Admin.where(username: username).first_or_initialize
      admin.username      = username
      admin.last_login_at = Time.now
      admin.save

      return admin
    rescue => e
      Rails.logger.error "[LDAP_AUTH]: Couldn't save user #{username}. #{e.message}"
      return false
    end
  end
end

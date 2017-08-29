domain = Rails.env.production? ? 'kaffevagnen.malmo.se' : '*.local.malmo.se'

Rails.application.config.session_store :cookie_store,
  key: '_kaffevagnen_session',
  domain: domain,
  secure: Rails.env.production? || Rails.env.test?,
  httponly: true

domain = Rails.env.production? ? 'mobilforsaljning.malmo.se' : 'local.malmo.se'

Rails.application.config.session_store :cookie_store,
  key: '_vagnar_session',
  # TODO: enable when subdomain is in place
  # domain: domain,
  secure: Rails.env.production? || Rails.env.test?,
  httponly: true

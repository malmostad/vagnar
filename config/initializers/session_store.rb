# TODO: change subdomain when in place
domain = Rails.env.production? ? 'srvubuwebhost29.malmo.se' : 'local.malmo.se'

Rails.application.config.session_store :cookie_store,
  key: '_vagnar_session',
  domain: domain,
  secure: Rails.env.production? || Rails.env.test?,
  httponly: true

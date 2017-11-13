require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vagnar
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.action_view.automatically_disable_submit_tag = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Stockholm'

    config.i18n.default_locale = 'sv'

    config.assets.paths += [
      Rails.root.join('vendor', 'malmo_shared_assets', 'stylesheets').to_s,
      Rails.root.join('vendor', 'malmo_shared_assets', 'stylesheets', 'shared').to_s,
      Rails.root.join('vendor', 'malmo_shared_assets', 'stylesheets', 'external').to_s
    ]
  end
end

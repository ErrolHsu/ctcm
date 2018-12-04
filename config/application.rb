require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ctcm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.eager_load_paths += %W( #{config.root}/app/jobs )

    config.time_zone = 'Taipei'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = "zh-TW"

    config.generators.system_tests = nil
    config.generators do |g|
      g.assets false
      g.javascript_engine :js
      g.stylesheet_engine :scss
      g.helper false
      # g.test_framework :rspec,
      #   fixtures: true,
      #   view_specs: false,
      #   helper_specs: false,
      #   routing_specs: false,
      #   request_specs: false
      # g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
# CONFIG = Rails.application.secrets

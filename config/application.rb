# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module NohEvent
   class Application < Rails::Application
      # Settings in config/environments/* take precedence over those specified here.
      # Application configuration should go into files in config/initializers
      # -- all .rb files in that directory are automatically loaded.
   end

   Rails.application.configure do
      config.assets.paths << config.root.join('node_modules')
      config.serve_static_assets = true
      config.assets.initialize_on_precompile = true

      config.generators do |g|
         g.test_framework :rspec,
                          fixtures: true,
                          view_specs: false,
                          helper_specs: false,
                          routing_specs: false,
                          controller_specs: true,
                          request_specs: false
         g.fixture_replacement :factory_girl, dir: 'spec/factories'
      end
   end
end

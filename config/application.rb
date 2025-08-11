require_relative "boot"
require "logger"

require "rails/all"

Bundler.require(*Rails.groups)

module Aybams
  class Application < Rails::Application
    config.load_defaults 7.0

    # Time zone
    config.time_zone = 'Central Time (US & Canada)'
    config.action_controller.raise_on_missing_callback_actions = false

    # Ensure method override middleware is enabled
    config.middleware.use Rack::MethodOverride

    # Ensure forms don't use remote by default
    config.action_view.form_with_generates_remote_forms = false

    # Generator settings
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false
    end
  end
end
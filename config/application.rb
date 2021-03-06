require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Demo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
	config.active_job.queue_adapter = :sidekiq
	#config.middleware.use ActionDispatch::ParamsParser
	#config.middleware.use 'CatchJsonParseErrors'
	require "./app/middleware/catch_json_parse_errors.rb"
	config.middleware.insert_before Rack::Head, CatchJsonParseErrors
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

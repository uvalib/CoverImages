require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module CoverImages
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths << Rails.root.join('lib')

    config.time_zone = 'Eastern Time (US & Canada)'
    config.authorized_users = YAML.load_file("#{Rails.root}/config/authorized_users.yml")

    config.filter_parameters << :password_confirmation

    if ENV["RAILS_LOG_TO_STDOUT"] && Rails.env != 'test'
      logger           = ActiveSupport::Logger.new(STDOUT)
      logger.formatter = config.log_formatter
      config.logger = ActiveSupport::TaggedLogging.new(logger)
    end

    # Configure cors headers
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins /https?:\/\/.*\.lib\.virginia\.edu:?\i*\z/,
          /localhost:\d/,
          /
            ^127\.0\.0\.1$                | # localhost
            ^(10                          | # private IP 10.x.x.x
            172\.(1[6-9]|2[0-9]|3[0-1])   | # private IP in the range 172.16.0.0 .. 172.31.255.255
            192\.168                        # private IP 192.168.x.x
            )\.
          /x,
          ENV['CORS_ALLOW_URL'].to_s
        resource '/cover_images/*', headers: :any, methods: [:get]
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module CoverImages
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_job.queue_adapter = :sidekiq


    config.autoload_paths << Rails.root.join('lib')

    config.time_zone = 'Eastern Time (US & Canada)'
    config.authorized_users = YAML.load_file("#{Rails.root.to_s}/config/authorized_users.yml")

    if ENV["RAILS_LOG_TO_STDOUT"].present?
      logger           = ActiveSupport::Logger.new(STDOUT)
      logger.formatter = config.log_formatter
      config.logger = ActiveSupport::TaggedLogging.new(logger)
    end

  end
end

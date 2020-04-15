require 'sidekiq/web'
Sidekiq.configure_server do |config|

  # production redis config goes here
  # https://github.com/mperham/sidekiq/wiki/Advanced-Options

  config.redis = { url: ENV["REDIS_URL"] } if ENV["REDIS_URL"].present?

  config.server_middleware do |chain|
    chain.add Sidekiq::Throttler
  end

  config.failures_max_count = 1000000

  config.logger.level = Logger::INFO
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"] } if ENV["REDIS_URL"].present?
end

Sidekiq::Web.app_url = "/"

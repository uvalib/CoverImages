require 'sidekiq/web'
Sidekiq.configure_server do |config|

  # production redis config goes here
  # https://github.com/mperham/sidekiq/wiki/Advanced-Options

  if ENV["REDIS_URL"].present?
    Sidekiq.configure_server do |config|
      config.redis = { url: ENV["REDIS_URL"] }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: ENV["REDIS_URL"] }
    end
  end



  config.server_middleware do |chain|
    chain.add Sidekiq::Throttler
  end

end
Sidekiq::Web.app_url = "/"

Sidekiq.configure_server do |config|

  # production redis config goes here
  # https://github.com/mperham/sidekiq/wiki/Advanced-Options

  if ENV["REDIS_URL"].present?
    Sidekiq.configure_server do |config|
      config.redis = { url: ENV["REDIS_URL"], namespace: "coverImages", password: ENV["REDIS_PASSWORD"] }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: ENV["REDIS_URL"], namespace: "coverImages", password: ENV["REDIS_PASSWORD"] }
    end
  end

  config.server_middleware do |chain|
    chain.add Sidekiq::Throttler
  end
end

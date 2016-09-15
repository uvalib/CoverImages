Sidekiq.configure_server do |config|

  # production redis config goes here
  # https://github.com/mperham/sidekiq/wiki/Advanced-Options

  config.server_middleware do |chain|
    chain.add Sidekiq::Throttler
  end
end

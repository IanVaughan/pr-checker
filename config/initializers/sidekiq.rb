require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'gitlab', size: 1, url: ENV['SIDEKIQ_REDIS_URL'] }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'gitlab', url: ENV['SIDEKIQ_REDIS_URL'] }
end

require 'pry'
require 'sidekiq'
require './lib/lab_stats'

require 'active_model/serializers'

require './lib/models/pipeline'
require './lib/models/merge_request'
require './lib/models/project'

require './lib/workers/projects'
require './lib/workers/project'
require './lib/workers/pipelines'
require './lib/workers/pipeline'
require './lib/workers/merge_requests'
require './lib/workers/merge_request'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'gitlab', size: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'gitlab' }
end

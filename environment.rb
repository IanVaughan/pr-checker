require 'dotenv'
Dotenv.load

require 'pry'

require './config/initializers/mongo'

require './lib/master_config'
require './lib/config_file_loader'
require './lib/collectors/github/issue_assigner'
require './lib/collectors/github/client'
require './lib/collectors/github/handler'

# Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

require './lib/collectors/gitlab/access'
require './lib/collectors/gitlab/project'
require './lib/collectors/gitlab/projects'
require './lib/collectors/gitlab/merge_requests'
require './lib/collectors/gitlab/pipelines'
require './lib/collectors/gitlab/pipeline'
require './lib/collectors/gitlab/jobs'

require './config/initializers/sidekiq'

require './lib/workers/projects'
require './lib/workers/project'
require './lib/workers/pipelines'
require './lib/workers/pipeline'
require './lib/workers/merge_requests'
require './lib/workers/merge_request'
require './lib/workers/jobs'
require './lib/workers/job'

module LabStats
end

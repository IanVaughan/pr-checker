require 'dotenv'
Dotenv.load

ENV['RACK_ENV'] ||= 'development'

require 'yaml'
require 'pry'

require './config/initializers/database'

require './lib/master_config'
require './lib/config_file_loader'

require './lib/collectors/github/issue_assigner'
require './lib/collectors/github/client'
require './lib/collectors/github/handler'
# Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }
require './lib/collectors/gitlab/access'
require './lib/collectors/gitlab/project'
require './lib/collectors/gitlab/projects'
require './lib/collectors/gitlab/branches'
require './lib/collectors/gitlab/system_hooks'
require './lib/collectors/gitlab/merge_requests'
require './lib/collectors/gitlab/merge_request'
require './lib/collectors/gitlab/notes'
require './lib/collectors/gitlab/pipelines'
require './lib/collectors/gitlab/pipeline'
require './lib/collectors/gitlab/jobs'
require './lib/collectors/gitlab/job_trace'

# require 'active_model/serializers'

require './lib/models/job'
require './lib/models/pipeline'
require './lib/models/merge_request'
require './lib/models/note'
require './lib/models/branch'
require './lib/models/project'

require './config/initializers/sidekiq'

require './lib/workers/projects'
require './lib/workers/branches'
require './lib/workers/branch'
require './lib/workers/project'
require './lib/workers/pipelines'
require './lib/workers/pipeline'
require './lib/workers/merge_requests'
require './lib/workers/merge_request'
require './lib/workers/jobs'
require './lib/workers/job'
require './lib/workers/notes'
require './lib/workers/job_trace'

module LabStats
end

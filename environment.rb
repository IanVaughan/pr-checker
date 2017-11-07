require 'dotenv'
Dotenv.load

ENV['RACK_ENV'] ||= 'development'

SERVER_URL = ENV.fetch('SERVER_URL')
GITLAB_SYSTEM_POST_HOOK = "/gitlab/hooks/system"
GITLAB_PROJECT_POST_HOOK = "/gitlab/hooks/project"

require 'yaml'
require 'pry'

require './config/initializers/database'
# require './config/initializers/datadog'

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
require './lib/collectors/gitlab/system_hooks_sync'
require './lib/collectors/gitlab/project_hooks'
require './lib/collectors/gitlab/project_hooks_sync'
require './lib/collectors/gitlab/merge_requests'
require './lib/collectors/gitlab/merge_request'
require './lib/collectors/gitlab/notes'
require './lib/collectors/gitlab/pipelines'
require './lib/collectors/gitlab/pipeline'
require './lib/collectors/gitlab/jobs'
require './lib/collectors/gitlab/job_trace'
require './lib/collectors/gitlab/handler'
require './lib/collectors/gitlab/labels'
require './lib/collectors/gitlab/users'

require './lib/models/job'
require './lib/models/pipeline'
require './lib/models/merge_request'
require './lib/models/note'
require './lib/models/branch'
require './lib/models/project'
require './lib/models/system_hook'
require './lib/models/project_hook'
require './lib/models/user'

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
require './lib/workers/maint'
require './lib/workers/project_labels'
require './lib/workers/users'

module LabStats
end

# TODO: Move to schedule
# Workers::Maint.perform_async

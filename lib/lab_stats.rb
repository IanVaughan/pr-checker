require 'dotenv'
Dotenv.load

require_relative 'initializers/mongo'

require_relative 'collectors/gitlab/access'
require_relative 'collectors/gitlab/project'
require_relative 'collectors/gitlab/projects'
require_relative 'collectors/gitlab/merge_requests'
require_relative 'collectors/gitlab/pipelines'
require_relative 'collectors/gitlab/pipeline'

module LabStats
end

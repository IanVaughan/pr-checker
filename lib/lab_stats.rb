require 'dotenv'
Dotenv.load

require_relative 'initializers/mongo'

# Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

require_relative 'collectors/gitlab/access'
require_relative 'collectors/gitlab/project'
require_relative 'collectors/gitlab/projects'
require_relative 'collectors/gitlab/merge_requests'
require_relative 'collectors/gitlab/pipelines'
require_relative 'collectors/gitlab/pipeline'
require_relative 'collectors/gitlab/jobs'

module LabStats
end

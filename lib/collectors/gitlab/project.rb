module Gitlab
  class Project < Access
    def call(id)
      # puts "Collecting project..."
      response_to_hash Gitlab.project(id)
    end
  end
end

module Gitlab
  class Project < Access
    def call(id)
      response_to_hash Gitlab.project(id)
    end
  end
end

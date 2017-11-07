module Gitlab
  class Labels < Access
    def call(project_id)
      response_to_array Gitlab.labels(project_id)
    end
  end
end

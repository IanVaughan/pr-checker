module Gitlab
  class Branches < Access
    def call(project_id)
      response_to_array Gitlab.branches(project_id)
    end
  end
end

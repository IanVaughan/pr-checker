module Gitlab
  class Branches < Access
    def call(project_id, page)
      # response_to_array Gitlab.branches(project_id, per_page: 20, page: page)
      response_to_array Gitlab.branches(project_id, page: page)
    end
  end
end

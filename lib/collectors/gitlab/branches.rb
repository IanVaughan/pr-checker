module Gitlab
  class Branches < Access
    # def call(project_id, page)
    def call(project_id)
      # response_to_array Gitlab.branches(project_id, per_page: 20, page: page)
      response_to_array Gitlab.branches(project_id)
    end
  end
end

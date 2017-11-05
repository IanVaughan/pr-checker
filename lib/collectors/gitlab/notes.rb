module Gitlab
  class Notes < Access
    def call(project_id, merge_request_id)
      # pipeline(project["path_with_namespace"], pipeline_id)
      response_to_array Gitlab.merge_request_notes(project_id, merge_request_id)
    end
  end
end

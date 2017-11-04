module Gitlab
  class MergeRequest < Access
    def call(project, merge_request_id)
      response_to_hash Gitlab.merge_request(project["path_with_namespace"], merge_request_id)
    end
  end
end

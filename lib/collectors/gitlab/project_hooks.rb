module Gitlab
  class ProjectHooks < Access
    def get_hooks(project_id)
      response_to_array Gitlab.project_hooks(project_id)
    end

    def add_hook(project_id, url)
      response_to_hash Gitlab.add_project_hook(
        project_id,
        "#{url}",
        push_events: true,
        merge_requests_events: true
      )
    end
  end
end

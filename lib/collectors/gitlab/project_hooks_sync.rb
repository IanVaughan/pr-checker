# Gitlab::ProjectHooksSync.new.ensure_hook_present(project_id: 20, url: SERVER_URL + GITLAB_PROJECT_POST_HOOK)
module Gitlab
  class ProjectHooksSync < Access
    def ensure_hook_present(project_id:, url: )
      @project = ::Project.find(project_id)

      remote_hooks = sync_hooks

      return true if remote_hooks.any? { |h| h.url == url }

      add_hook(url).tap { |new_gitlab_hook| save_system_hook(new_gitlab_hook) }
    end

    private

    attr_reader :project

    def sync_hooks
      get_hooks.map { |gitlab_hook| save_system_hook(gitlab_hook) }
    end

    def save_system_hook(gitlab_hook)
      project.project_hooks.find_or_initialize_by(id: gitlab_hook[:id]).tap do |hook|
        hook.update!(
          id: gitlab_hook[:id],
          url: gitlab_hook[:url],
          push_events: gitlab_hook[:push_events],
          tag_push_events: gitlab_hook[:tag_push_events],
          repository_update_events: gitlab_hook[:repository_update_events],
          enable_ssl_verification: gitlab_hook[:enable_ssl_verification],

          issues_events: gitlab_hook[:issues_events],
          merge_requests_events: gitlab_hook[:merge_requests_events],
          note_events: gitlab_hook[:note_events],
          pipeline_events: gitlab_hook[:pipeline_events],
          wiki_page_events: gitlab_hook[:wiki_page_events],
          job_events: gitlab_hook[:job_events]
        )
      end
    end

    def get_hooks
      ProjectHooks.new.get_hooks(project.id)
    end

    def add_hook(url)
      ProjectHooks.new.add_hook(project.id, url)
    end
  end
end

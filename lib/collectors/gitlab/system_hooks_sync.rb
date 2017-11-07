# Gitlab::SystemHooksSync.new.ensure_hook_present(url: SERVER_URL + GITLAB_SYSTEM_POST_HOOK)
module Gitlab
  class SystemHooksSync < Access
    def ensure_hook_present(url: )
      remote_hooks = sync_hooks

      return true if remote_hooks.any? { |h| h.url == url }

      add_hook(url).tap { |new_gitlab_hook| save_system_hook(new_gitlab_hook) }
    end

    def sync_hooks
      get_hooks.map { |gitlab_hook| save_system_hook(gitlab_hook) }
    end

    def save_system_hook(new_gitlab_hook)
      SystemHook.find_or_initialize_by(id: new_gitlab_hook[:id]).tap do |system_hook|
        system_hook.update!(
          id: new_gitlab_hook[:id],
          url: new_gitlab_hook[:url],
          push_events: new_gitlab_hook[:push_events],
          tag_push_events: new_gitlab_hook[:tag_push_events],
          repository_update_events: new_gitlab_hook[:repository_update_events],
          enable_ssl_verification: new_gitlab_hook[:enable_ssl_verification]
        )
      end
    end

    def get_hooks
      SystemHooks.new.get_hooks
    end

    def add_hook(url)
      SystemHooks.new.add_hook(url)
    end
  end
end

# Gitlab::SystemHooksSync.new.ensure_hook_present(url: SERVER_URL + GITLAB_SYSTEM_POST_HOOK)
module Gitlab
  class SystemHooksSync < Access
    # {:event_name=>"repository_update", :user_id=>10, :user_name=>"john.doe", :user_email=>"test@example.com", :user_avatar=>"http://example.com/avatar/user.png", :project_id=>40, :changes=>[{:before=>"8205ea8d81ce0c6b90fbe8280d118cc9fdad6130", :after=>"4045ea7a3df38697b3730a20fb73c8bed8a3e69e", :ref=>"refs/heads/master"}], :refs=>["refs/heads/master"]}
    # {:object_kind=>"push", :event_name=>"push", :before=>"95790bf891e76fee5e1747ab589903a6a1f80f22", :after=>"da1560886d4f094c3e6c9ef40349f7d38b5d27d7", :ref=>"refs/heads/master", :checkout_sha=>"da1560886d4f094c3e6c9ef40349f7d38b5d27d7", :message=>"Hello World", :user_id=>4, :user_name=>"John Smith", :user_email=>"john@example.com", :user_avatar=>"https://s.gravatar.com/avatar/d4c74594d841139328695756648b6bd6?s=8://s.gravatar.com/avatar/d4c74594d841139328695756648b6bd6?s=80", :project_id=>15, :commits=>[{:id=>"c5feabde2d8cd023215af4d2ceeb7a64839fc428", :message=>"Add simple search to projects in public area", :timestamp=>"2013-05-13T18:18:08+00:00", :url=>"https://test.example.com/gitlab/gitlabhq/commit/c5feabde2d8cd023215af4d2ceeb7a64839fc428", :author=>{:name=>"Test User", :email=>"test@example.com"}}], :total_commits_count=>1}

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

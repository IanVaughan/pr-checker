module Gitlab
  class SystemHooks < Access
    def get_hooks
      response_to_array Gitlab.hooks
    end

    def add_hook(url)
      response_to_hash Gitlab.add_system_hook("#{url}", push_events: true)
    end
  end
end

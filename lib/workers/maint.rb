module Workers
  class Maint
    include Sidekiq::Worker

    def perform
      logger.info 'Workers::Maint...'

      Gitlab::SystemHooks.new.ensure_hook_present(url: GITLAB_POST_SERVER + GITLAB_POST_HOOK)
      # lables
    end
  end
end

module Workers
  class Project
    include Sidekiq::Worker

    def update_all(merge_requests: true, pipelines: true, branches: true, webhooks: true)
      ::Project.each do |project|
        Project.perform_async(project.id, merge_requests, branches, pipelines, webhooks)
      end
    end

    def perform(project_id, merge_requests = true, pipelines = true, branches = true, webhooks = true)
      logger.info "*** Workers::Project project_id:#{project_id}"
      save_details(project_id)

      MergeRequests.perform_async(project_id) if merge_requests
      Pipelines.perform_async(project_id) if pipelines
      Branches.perform_async(project_id) if branches

      if webhooks
        Gitlab::ProjectHooks.new.ensure_hook_present(
          project_id: project_id,
          url: SERVER_URL + GITLAB_PROJECT_POST_HOOK
        )
      end
    end

    def save_details(project_id)
      project = ::Project.find(project_id)
      info = project_details(project_id)
      project.update!(info: info)
    end

    def project_details(project_id)
      Gitlab::Project.new.call(project_id)
    end
  end
end

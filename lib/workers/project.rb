module Workers
  class Project
    include Sidekiq::Worker

    def perform(project_id)
      logger.info "Workers::Project project_id:#{project_id}"
      save_details(project_id)

      MergeRequests.perform_async(project_id)
      Pipelines.perform_async(project_id)
      Branches.perform_async(project_id)
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

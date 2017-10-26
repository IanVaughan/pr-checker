module Workers
  class Pipeline
    include Sidekiq::Worker

    def perform(project_id, pipeline_id)
      logger.info "Workers::Pipelines project_id:#{project_id}, pipeline_id:#{pipeline_id}"
      Jobs.perform_async(project_id, pipeline_id)

      project = Models::Project.find(project_id)
      pipeline = project.pipelines.find(pipeline_id)

      # TODO: Checks
    end
  end
end

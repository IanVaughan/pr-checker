module Workers
  class Pipeline
    include Sidekiq::Worker

    def perform(project_id, pipeline_id)
      logger.info "Workers::Pipeline project_id:#{project_id}, pipeline_id:#{pipeline_id}"
      Jobs.perform_async(project_id, pipeline_id)

      project = ::Project.find(project_id)
      pipeline = project.pipelines.find(pipeline_id)

      pipeline_details = Gitlab::Pipeline.new.call(project, pipeline.id)
      pipeline.update!(info: pipeline_details)

      # TODO: Checks
    end
  end
end

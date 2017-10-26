module Workers
  class Pipelines
    include Sidekiq::Worker

    def perform(project_id)
      logger.info "Workers::Pipelines project_id:#{project_id}"

      project = Models::Project.find(project_id)
      pipelines = Gitlab::Pipelines.new.call(project)
      logger.info "Workers::Pipelines project_id:#{project_id}, count:#{pipelines.count}"

      pipelines.each do |pipeline|
        logger.info "Workers::Pipeline project_id:#{project_id}, pipeline_id:#{pipeline[:id]}"

        pl = project.pipelines.build(pipeline)
        project.save!

        Pipeline.perform_async(project_id, pl.id)
      end
    end
  end
end

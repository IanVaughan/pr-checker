module Workers
  class Pipelines
    include Sidekiq::Worker

    def perform(project_id, page: nil)
      project = ::Project.find(project_id)

      page = 1 if page.nil?
      pipelines = Gitlab::Pipelines.new.call(project, page)
      logger.info "Workers::Pipelines project_id:#{project_id}, count:#{pipelines.count}, page:#{page}"
      Pipelines.perform_async(project_id, page + 1) if pipelines.any?

      pipelines.each do |pipeline|
        logger.info "Workers::Pipeline project_id:#{project_id}, pipeline_id:#{pipeline[:id]}"

        project.pipelines.create!(id: pipeline[:id], info: pipeline)

        Pipeline.perform_async(project_id, pipeline[:id])
      end
    end
  end
end

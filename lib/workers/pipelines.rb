module Workers
  class Pipelines
    include Sidekiq::Worker

    def perform(project_id)
      project = ::Project.find(project_id)

      pipelines = Gitlab::Pipelines.new.call(project)
      logger.info "Workers::Pipelines project_id:#{project_id}, count:#{pipelines.count}"

      pipelines.each do |pipeline|
        logger.info "Workers::Pipelines project_id:#{project_id}, pipeline_id:#{pipeline[:id]}"

        project.pipelines.find_or_create_by(id: pipeline[:id]).tap do |pl|
          pl.update!(
            sha: pipeline[:sha],
            ref: pipeline[:ref],
            status: pipeline[:status]
          )
        end

        Pipeline.perform_async(project_id, pipeline[:id])
      end
    end
  end
end

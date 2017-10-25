module Workers
  class Pipeline
    include Sidekiq::Worker

    def perform(project_id, pipeline_id)
      # puts "Workers::Pipelines:#{project_id}"
      project = Models::Project.find(project_id)
      pipeline = project.pipelines.find(pipeline_id)

      # TODO: Checks

      Jobs.perform_async(project.id, pipeline.id)
    end
  end
end

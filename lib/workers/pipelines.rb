module Workers
  class Pipelines
    include Sidekiq::Worker

    def perform(project_id)
      puts "Workers::Pipelines:#{project_id}"
      project = Models::Project.find(project_id)
      pipelines(project).each do |pipeline|
        puts "Workers::Pipeline:#{pipeline[:id]}"
        pl = project.pipelines.build(pipeline)
        project.save!

        Pipeline.perform_async(project_id, pl.id)
      end
    end

    private

    def pipelines(project)
      Gitlab::Pipelines.new.call(project)
    end
  end
end

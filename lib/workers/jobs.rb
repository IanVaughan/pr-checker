module Workers
  class Jobs
    include Sidekiq::Worker

    def perform(project_id, pipeline_id)
      puts "Workers::Jobs:#{project_id}, #{pipeline_id}"

      project = project(project_id)
      pipeline = project.pipelines.find(pipeline_id)
      jobs = jobs(project, pipeline)
      jobs.each do |job|
        pipeline.jobs.build(job)
        pipeline.save!

        Job.perform_async(project_id, pipeline_id, job[:id])
      end
    end

    private

    def project(project_id)
      Models::Project.find(project_id)
    end

    def jobs(project, pipeline)
      Gitlab::Jobs.new.call(project, pipeline)
    end
  end
end

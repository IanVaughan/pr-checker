module Workers
  class Jobs
    include Sidekiq::Worker

    def perform(project_id, pipeline_id)
      logger.info "Workers::Jobs project_id:#{project_id}, pipeline_id:#{pipeline_id}"

      project = Models::Project.find(project_id)
      pipeline = project.pipelines.find(pipeline_id)
      jobs = Gitlab::Jobs.new.call(project, pipeline)
      logger.info "Workers::Jobs project_id:#{project_id}, pipeline_id:#{pipeline_id}, count:#{jobs.count}"

      jobs.each do |job|
        logger.info "Workers::Jobs project_id:#{project_id}, pipeline_id:#{pipeline_id}, job_id:#{job[:id]}"

        pipeline.jobs.build(job)
        pipeline.save!

        Job.perform_async(project_id, pipeline_id, job[:id])
        JobTrace.perform_async(project_id, job[:id])
      end
    end
  end
end

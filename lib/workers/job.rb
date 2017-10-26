module Workers
  class Job
    include Sidekiq::Worker

    def perform(project_id, pipeline_id, job_id)
      logger.info "Workers::Job project_id:#{project_id}, pipeline_id:#{pipeline_id}, job_id:#{job_id}"

      project = Models::Project.find(project_id)
      pipeline = project.pipelines.find(pipeline_id)
      job = pipeline.jobs.find(job_id)

      # TODO: check job
    end
  end
end

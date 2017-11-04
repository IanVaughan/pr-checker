module Workers
  class Jobs
    include Sidekiq::Worker

    def perform(project_id, pipeline_id)
      logger.info "Workers::Jobs project_id:#{project_id}, pipeline_id:#{pipeline_id}"

      project = ::Project.find(project_id)
      pipeline = project.pipelines.find(pipeline_id)
      jobs = Gitlab::Jobs.new.call(project, pipeline_id)

      logger.info "Workers::Jobs project_id:#{project_id}, pipeline_id:#{pipeline_id}, count:#{jobs.count}"

      jobs.each do |job|
        logger.info "Workers::Jobs project_id:#{project_id}, pipeline_id:#{pipeline_id}, job_id:#{job[:id]}"

        pipeline.jobs.find_or_create_by!(id: job[:id]) { |j| j.update info: job }

        Job.perform_async(project_id, pipeline_id, job[:id])
        JobTrace.perform_async(project_id, job[:id])
      end
    end
  end
end

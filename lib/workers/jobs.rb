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

        pipeline.jobs.find_or_create_by(id: job[:id]).tap do |j|
          j.update!(
            status: job[:status],
            stage: job[:stage],
            name: job[:name],
            ref: job[:ref],
            tag: job[:tag],
            started_at: job[:started_at],
            finished_at: job[:finished_at],
            user: job[:user],
            commit: job[:commit],
            runner: job[:runner]
          )
        end

        Job.perform_async(project_id, pipeline_id, job[:id])
        JobTrace.perform_async(project_id, job[:id])
      end
    end
  end
end

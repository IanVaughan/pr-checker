module Workers
  class JobTrace
    include Sidekiq::Worker

    def perform(project_id, job_id)
      logger.info "Workers::JobTrace project_id:#{project_id}, job_id:#{job_id}"

      project = ::Project.find(project_id)
      trace = Gitlab::JobTrace.new.call(project[:path_with_namespace], job_id)
      # pipeline = project.pipelines.find(pipeline_id)
      # job = pipeline.jobs.find(job_id)
      job = ::Job.find(job_id)
      # job.update!(trace: trace)

      # data = Gitlab::JobTrace.new.call(20, id);
      # compressed_data = Zlib::Deflate.deflate(data);
      # data.size # => 35246
      # compressed_data.size # => 9476

      # TODO: check trace
    end
  end
end

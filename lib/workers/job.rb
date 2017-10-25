module Workers
  class Job
    include Sidekiq::Worker

    def perform(project_id, pipeline_id, job_id)
      # puts "Workers::Job:#{project_id}, #{job_id}"

      project = Models::Project.find(project_id)
      pipeline = project.pipelines.find(pipeline_id)
      job = pipeline.jobs.find(job_id)

      # puts job
      # puts "-"*100

      # TODO: check job
    end

    private

    def project(project_id)
      Models::Project.find(project_id)
    end
  end
end

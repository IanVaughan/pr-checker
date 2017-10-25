module Workers
  class Project
    include Sidekiq::Worker

    def perform(project_id)
      puts "Workers::Project:#{project_id}"
      save_details(project_id)

      MergeRequests.perform_async(project_id)
      Pipelines.perform_async(project_id)
    end

    def save_details(project_id)
      project = Models::Project.find(project_id)
      dets = project_details(project_id)
      project.update_attributes!(dets)
      project.save!
    end

    def project_details(project_id)
      Gitlab::Project.new.call(project_id)
    end
  end
end

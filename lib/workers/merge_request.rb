module Workers
  class MergeRequest
    include Sidekiq::Worker

    def perform(project_id, mr_id)
      logger.info "Workers::MergeRequest project_id:#{project_id}, mr_id:#{mr_id}"
      
      mr = Models::Project.find(project_id).merge_requests.find(mr_id)
    end
  end
end

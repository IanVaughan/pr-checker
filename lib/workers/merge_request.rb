module Workers
  class MergeRequest
    include Sidekiq::Worker

    def perform(project_id, mr_id)
      logger.info "Workers::MergeRequest project_id:#{project_id}, mr_id:#{mr_id}"

      project = ::Project.find(project_id)
      mr = project.merge_requests.find(mr_id)
      info = Gitlab::MergeRequest.new.call(project, mr.iid)
      mr.update!(info: info)

      Notes.perform_async(project_id, mr_id)

      # TODO: Check MergeRequest
      # Age
      # Labels?
    end
  end
end

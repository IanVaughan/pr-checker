module Workers
  class MergeRequest
    include Sidekiq::Worker

    def perform(project_id, merge_request_id)
      logger.info "Workers::MergeRequest project_id:#{project_id}, merge_request_id:#{merge_request_id}"

      project = ::Project.find(project_id)
      mr = project.merge_requests.find(merge_request_id)
      info = Gitlab::MergeRequest.new.call(project, mr.iid)
      mr.update!(info: info)

      Notes.perform_async(project_id, merge_request_id)

      # TODO: Check MergeRequest
      # Age
      # Labels?
    end
  end
end

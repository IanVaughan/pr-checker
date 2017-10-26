module Workers
  class MergeRequests
    include Sidekiq::Worker

    def perform(project_id)
      logger.info "Workers::MergeRequests project_id:#{project_id}"

      project = Models::Project.find(project_id)
      merge_requests = Gitlab::MergeRequests.new.call(project)
      logger.info "Workers::MergeRequests project_id:#{project_id}, count:#{merge_requests.count}"

      merge_requests.each do |mr|
        logger.info "Workers::MergeRequests project_id:#{project_id}, mr:#{mr[:id]}"

        mr = project.merge_requests.build(mr)
        project.save!

        MergeRequest.perform_async(project_id, mr.id)
      end
    end
  end
end

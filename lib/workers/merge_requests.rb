module Workers
  class MergeRequests
    include Sidekiq::Worker

    def perform(project_id)
      project = ::Project.find(project_id)
      merge_requests = Gitlab::MergeRequests.new.call(project)
      logger.info "Workers::MergeRequests project_id:#{project_id}, count:#{merge_requests.count}"

      merge_requests.each do |mr|
        logger.info "Workers::MergeRequests project_id:#{project_id}, mr:#{mr[:id]}"

        project.merge_requests.create!(id: mr[:id], title: mr[:title], info: mr)

        MergeRequest.perform_async(project_id, mr[:id])
      end
    end
  end
end

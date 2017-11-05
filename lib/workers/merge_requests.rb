module Workers
  class MergeRequests
    include Sidekiq::Worker

    def perform(project_id, page = nil)
      project = ::Project.find(project_id)

      page = 1 if page.nil?
      merge_requests = Gitlab::MergeRequests.new.call(project, page)
      logger.info "Workers::MergeRequests project_id:#{project_id}, count:#{merge_requests.count}, page:#{page}"
      MergeRequests.perform_async(project_id, page) if merge_requests.any?

      merge_requests.each do |merge_request|
        logger.info "Workers::MergeRequests project_id:#{project_id}, merge_request:#{merge_request[:id]}"

        project.merge_requests.find_or_create_by(id: merge_request[:id]).tap do |mr|
          mr.update!(
            iid: merge_request[:iid],
            title: merge_request[:title],
            description: merge_request[:description] || "(empty)",
            state: merge_request[:state],
            web_url: merge_request[:web_url]
          )
        end

        MergeRequest.perform_async(project_id, merge_request[:id])
      end
    end
  end
end

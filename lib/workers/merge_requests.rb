module Workers
  class MergeRequests
    include Sidekiq::Worker

    def perform(project_id)
      project = ::Project.find(project_id)

      merge_requests = Gitlab::MergeRequests.new.call(project)
      logger.info "Workers::MergeRequests project_id:#{project_id}, count:#{merge_requests.count}"

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

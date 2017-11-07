module Workers
  class Notes
    include Sidekiq::Worker

    def update_all
      ::Project.each do |project|
        project.merge_requests.each do |merge_request|
          Notes.perform_async(project.id, merge_request.id)
        end
      end
    end

    def perform(project_id, merge_request_id)
      logger.info "Workers::MergeRequest project_id:#{project_id}, merge_request_id:#{merge_request_id}"

      project = ::Project.find(project_id)
      merge_request = project.merge_requests.find(merge_request_id)
      gitlab_notes = Gitlab::Notes.new.call(project.id, merge_request.iid)

      gitlab_notes.each do |gitlab_note|
        merge_request.notes.find_or_create_by(id: gitlab_note[:id]).tap do |note|
          note.update!(
            body: gitlab_note[:body],
            attachment: gitlab_note[:attachment],
            author: gitlab_note[:author],
            system: gitlab_note[:system],
            noteable_id: gitlab_note[:noteable_id],
            noteable_type: gitlab_note[:noteable_type],
            noteable_iid: gitlab_note[:noteable_iid],
            merge_request: gitlab_note[:merge_request]
          )
        end
      end

      # TODO: Check notes
    end
  end
end

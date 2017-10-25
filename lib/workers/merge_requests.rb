module Workers
  class MergeRequests
    include Sidekiq::Worker

    def perform(project_id)
      puts "Workers::MergeRequests project_id:#{project_id}"
      project = Models::Project.find(project_id)
      mrs = merge_requests(project)
      mrs.each do |mr|
        mr = project.merge_requests.build(mr)
        project.save!

        MergeRequest.perform_async(project_id, mr.id)
      end
    end

    private

    def merge_requests(project)
      Gitlab::MergeRequests.new.call(project)
    end
  end
end

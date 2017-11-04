module Workers
  class Branches
    include Sidekiq::Worker

    def perform(project_id, page = nil)
      logger.info "Workers::Branches project_id:#{project_id}"

      project = ::Project.find(project_id)
      page = 1 if page.nil?
      branches = Gitlab::Branches.new.call(project_id, page)
      logger.info "Workers::Branches project_id:#{project_id}, count:#{branches.count}, page:#{page}"
      Branches.perform_async(project_id, page + 1) if branches.any?

      branches.each do |branch|
        logger.info "Workers::Branches project_id:#{project_id}, branch_id:#{branch[:id]}"

        project.branches.find_or_create_by(id: branch[:id]).tap do |br|
          br.update!(
            name: branch[:name],
            commit: branch[:commit],
            merged: branch[:merged],
            protected: branch[:protected],
            developers_can_push: branch[:developers_can_push],
            developers_can_merge: branch[:developers_can_merge]
          )
        end

        Branch.perform_async(project_id, branch[:id])
      end
    end
  end
end

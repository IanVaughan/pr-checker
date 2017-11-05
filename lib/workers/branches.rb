module Workers
  class Branches
    include Sidekiq::Worker

    def perform(project_id)
      logger.info "Workers::Branches project_id:#{project_id}"

      project = ::Project.find(project_id)
      branches = Gitlab::Branches.new.call(project_id)
      logger.info "Workers::Branches project_id:#{project_id}, count:#{branches.count}"

      branches.each do |branch|
        logger.info "Workers::Branches project_id:#{project_id}, branch_id:#{branch[:name]}"

        project.branches.find_or_create_by(name: branch[:name]).tap do |br|
          br.update!(
            commit: branch[:commit],
            merged: branch[:merged],
            protected: branch[:protected],
            developers_can_push: branch[:developers_can_push],
            developers_can_merge: branch[:developers_can_merge]
          )
        end

        Branch.perform_async(project_id, branch[:name])
      end
    end
  end
end

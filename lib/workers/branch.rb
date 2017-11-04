module Workers
  class Branch
    include Sidekiq::Worker

    def perform(project_id, branch_id)
      logger.info "Workers::Branches project_id:#{project_id}, branch_id:#{branch_id}"

      project = ::Project.find(project_id)
      branch = project.branches.find(branch_id)
    end
  end
end

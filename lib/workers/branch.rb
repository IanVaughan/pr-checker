# Checker
module Workers
  class Branch
    include Sidekiq::Worker

    def perform(project_id, branch_name)
      logger.info "Workers::Branch project_id:#{project_id}, branch_id:#{branch_name}"

      project = ::Project.find(project_id)
      branch = project.branches.find_by(name: branch_name)

      delete_branch(project_id, branch) if branch.merged?
      # delete_branch(project_id, branch) if branch.commit["created_at"] < 1.year.ago
    end

    def delete_branch(project_id, branch)
      logger.info "Workers::Branch deleting branch project_id:#{project_id}, branch:#{branch.name}"
      Gitlab.delete_branch(project_id, branch.name)
    end
  end
end

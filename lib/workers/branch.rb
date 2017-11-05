module Workers
  class Branch
    include Sidekiq::Worker

    def perform(project_id, branch_name)
      logger.info "Workers::Branches project_id:#{project_id}, branch_id:#{branch_name}"

      project = ::Project.find(project_id)
      branch = project.branches.find_by(name: branch_name)

      delete_old_branch(branch)

      # => {:name=>"no-wait-for-upgrade--split",
      #  :commit=>
      #   {"id"=>"3e57785279693c8bb16851325ebf6bde059e669a",
      #    "short_id"=>"3e577852",
      #    "title"=>"fix",
      #    "created_at"=>"2017-07-17T13:38:07.000+01:00",
      #    "parent_ids"=>["3bea1b44c4c4c7c15ab71e4e65b9ef2e12a78634"],
      #    "message"=>"fix\n",
      #    "author_name"=>"Ian Vaughan",
      #    "author_email"=>"ian@quiqup.com",
      # "authored_date"=>"2017-07-17T13:38:07.000+01:00",
      # "committer_name"=>"Ian Vaughan",
      # "committer_email"=>"ian@quiqup.com",
      # "committed_date"=>"2017-07-17T13:38:07.000+01:00"},
    end

    def delete_old_branch(branch)
      # branch.info[:commit][:authored_date]
    end

    # TODO: Check
    # Age
    # Group and email owner
    # Delete
  end
end

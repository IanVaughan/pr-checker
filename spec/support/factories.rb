
# [3] pry(main)> Gitlab::Projects.new.call.last
# => {:id=>2,
#  :description=>"",
#  :default_branch=>"master",
#  :tag_list=>[],
#  :ssh_url_to_repo=>"git@gitlab.quiqup.com:backend/QuApiDevtools.git",
#  :http_url_to_repo=>"https://gitlab.quiqup.com/backend/QuApiDevtools.git",
#  :web_url=>"https://gitlab.quiqup.com/backend/QuApiDevtools",
#  :name=>"QuApiDevtools",
#  :name_with_namespace=>"backend / QuApiDevtools",
#  :path=>"QuApiDevtools",
#  :path_with_namespace=>"backend/QuApiDevtools",
#  :star_count=>1,
#  :forks_count=>0,
#  :created_at=>"2016-12-17T20:38:16.718Z",
#  :last_activity_at=>"2017-10-11T10:43:37.449Z"}

def project_basic_fixture
  load_fixture_yml('gitlab/formatted/project_basic.yml')
end

# [1] pry(main)> Gitlab::Project.new.call(20)
# => {:id=>20,
#  :description=>"Quiqup Ruby API based on Rails and Grape",
#  :default_branch=>"master",
#  :tag_list=>["api"],
#  :ssh_url_to_repo=>"git@gitlab.quiqup.com:backend/CoreAPI.git",
#  :http_url_to_repo=>"https://gitlab.quiqup.com/backend/CoreAPI.git",
#  :web_url=>"https://gitlab.quiqup.com/backend/CoreAPI",
#  :name=>"CoreAPI",
#  :name_with_namespace=>"backend / CoreAPI",
#  :path=>"CoreAPI",
#  :path_with_namespace=>"backend/CoreAPI",
#  :star_count=>11,
#  :forks_count=>0,
#  :created_at=>"2016-12-17T22:37:54.176Z",
#  :last_activity_at=>"2017-11-04T16:22:44.111Z",
#  :_links=>
#   {"self"=>"http://gitlab.quiqup.com/api/v4/projects/20",
#    "issues"=>"http://gitlab.quiqup.com/api/v4/projects/20/issues",
#    "merge_requests"=>"http://gitlab.quiqup.com/api/v4/projects/20/merge_requests",
#    "repo_branches"=>"http://gitlab.quiqup.com/api/v4/projects/20/repository/branches",
#    "labels"=>"http://gitlab.quiqup.com/api/v4/projects/20/labels",
#    "events"=>"http://gitlab.quiqup.com/api/v4/projects/20/events",
#    "members"=>"http://gitlab.quiqup.com/api/v4/projects/20/members"},
#  :archived=>false,
#  :visibility=>"internal",

def project_full_fixture
  load_fixture_yml('gitlab/formatted/project_full.yml')
end

def create_project(full: false)
  Project.create!(project_basic_fixture) do |p|
    p.update!(info: project_full_fixture) if full
  end
end

# [6] pry(main)> Gitlab::Pipelines.new.call(project, 1).last
  # => {:id=>52, :sha=>"3b8ea787594ca16545dccff9c14d04917c6b61af", :ref=>"gitlab-ci", :status=>"failed"}

def pipeline_basic_fixture
  load_fixture_yml('gitlab/formatted/pipeline_basic.yml')
end

# [4] pry(main)> Gitlab::Pipeline.new.call(project, 35472)
  # => {:id=>35472,
  #  :sha=>"302e62208033d85a4fe7211a7dca6db41401063a",
  #  :ref=>"0.264.0",
  #  :status=>"failed",
  #  :before_sha=>"302e62208033d85a4fe7211a7dca6db41401063a",
  #  :tag=>true,
  #  :yaml_errors=>nil,
  #  :user=>
  #   {"id"=>37,
  #    "name"=>"GitLab CI Tagger",
  #    "username"=>"gitlab-ci-tagger",
  #    "state"=>"active",
  #    "avatar_url"=>"https://secure.gravatar.com/avatar/ff681c8977f128e3f88ee9d452b35560?s=80&d=identicon",
  #    "web_url"=>"https://gitlab.quiqup.com/gitlab-ci-tagger"},
  #  :created_at=>"2017-11-03T22:15:25.345Z",
  #  :updated_at=>"2017-11-03T22:22:58.090Z",
  #  :started_at=>"2017-11-03T22:15:28.011Z",
  #  :finished_at=>"2017-11-03T22:22:58.084Z",
  #  :committed_at=>nil,
  #  :duration=>446,
  #  :coverage=>nil}

def pipeline_full_fixture
  load_fixture_yml('gitlab/formatted/pipeline_full.yml')
end

def create_pipeline(project = create_project, info: pipeline_full_fixture)
  pd = pipeline_basic_fixture

  project.pipelines.create!(
    id: pd[:id],
    sha: pd[:sha],
    ref: pd[:ref],
    status: pd[:status],
    info: info
  )
end

# => {:id=>139735,
  #  :status=>"success",
  #  :stage=>"build_image",
  #  :name=>"Build tagged image",
  #  :ref=>"0.264.0",
  #  :tag=>true,
  #  :coverage=>nil,
  #  :created_at=>"2017-11-03T22:15:25.363Z",
  #  :started_at=>"2017-11-03T22:15:27.944Z",
  #  :finished_at=>"2017-11-03T22:17:01.673Z",
  #  :user=>
  #   {"id"=>37,
  #    "name"=>"GitLab CI Tagger",
  #    "username"=>"gitlab-ci-tagger",
  #    "state"=>"active",
  #    "avatar_url"=>"https://secure.gravatar.com/avatar/ff681c8977f128e3f88ee9d452b35560?s=80&d=identicon",
  #    "web_url"=>"https://gitlab.quiqup.com/gitlab-ci-tagger",
  #    "created_at"=>"2017-04-06T15:39:41.072Z",
  #    "bio"=>nil,
  #    "location"=>nil,
  #    "skype"=>"",
  #    "linkedin"=>"",
  #    "twitter"=>"",
  #    "website_url"=>"",
  #    "organization"=>nil},
  #  :commit=>
  #   {"id"=>"302e62208033d85a4fe7211a7dca6db41401063a",
  #    "short_id"=>"302e6220",
  #    "title"=>"Merge branch 'fix-matchdata-bug' into 'master'",
  #    "created_at"=>"2017-11-03T22:03:55.000+00:00",
  #    "parent_ids"=>["2be3f526cdbd501825dac881674fa62ecb1a7c08", "9ddfbad01ed7057fefd498486cc05ed94153e573"],
  #    "message"=>"Merge branch 'fix-matchdata-bug' into 'master'\n\nEnsure that can_assign returns a boolean value\n\nSee merge request backend/CoreAPI!6235",
  #    "author_name"=>"Gonzalo Quero",
  #    "author_email"=>"gonzalo@quiqup.com",
  #    "authored_date"=>"2017-11-03T22:03:55.000+00:00",
  #    "committer_name"=>"Gonzalo Quero",
  #    "committer_email"=>"gonzalo@quiqup.com",
  #    "committed_date"=>"2017-11-03T22:03:55.000+00:00"},
  #  :runner=>{"id"=>70, "description"=>"runner-01.quiq.ly", "active"=>true, "is_shared"=>true, "name"=>"gitlab-ci-multi-runner"},
  #  :pipeline=>{"id"=>35472, "sha"=>"302e62208033d85a4fe7211a7dca6db41401063a", "ref"=>"0.264.0", "status"=>"failed"}}

def job_fixture
  load_fixture_yml('gitlab/formatted/job.yml')
end

def create_job(pipeline = create_pipeline)
  jf = job_fixture

  pipeline.jobs.create!(
    id: jf[:id],
    status: jf[:status],
    stage: jf[:stage],
    name: jf[:name],
    ref: jf[:ref],
    tag: jf[:tag],
    coverage: jf[:coverage],
    created_at: jf[:created_at],
    started_at: jf[:started_at],
    finished_at: jf[:finished_at],
    user: jf[:user],
    commit: jf[:commit],
    runner: jf[:runner]
  )
end

# [3] pry(main)> Gitlab::MergeRequests.new.call(project, 1).last
  # => {:id=>3169,
  #  :iid=>1,
  #  :project_id=>20,
  #  :title=>"Add Account to AP",
  #  :description=>"*Created by: rbndrsn*\n\n",
  #  :state=>"closed",
  #  :created_at=>"2014-04-09T18:06:20.000Z",
  #  :updated_at=>"2014-04-09T18:09:16.000Z",
  #  :web_url=>"https://gitlab.quiqup.com/backend/CoreAPI/merge_requests/1"}

def merge_request_basic_fixture
  load_fixture_yml('gitlab/formatted/merge_request_basic.yml')
end

# [8] pry(main)> Gitlab::MergeRequest.new.call(project, 1)
  # => {:id=>3169,
  #  :iid=>1,
  #  :project_id=>20,
  #  :title=>"Add Account to AP",
  #  :description=>"*Created by: rbndrsn*\n\n",
  #  :state=>"closed",
  #  :created_at=>"2014-04-09T18:06:20.000Z",
  #  :updated_at=>"2014-04-09T18:09:16.000Z",
  #  :target_branch=>"master",
  #  :source_branch=>"pull/1/feature/account-page-1",
  #  :upvotes=>0,
  #  :downvotes=>0,
  #  :author=>
  #   {"id"=>2,
  #    "name"=>"Danny Hawkins",
  #    "username"=>"danhawkins",
  #    "state"=>"active",
  #    "avatar_url"=>"https://gitlab.quiqup.com/uploads/-/system/user/avatar/2/avatar.png",
  #    "web_url"=>"https://gitlab.quiqup.com/danhawkins"},
  #  :assignee=>nil,
  #  :source_project_id=>20,
  #  :target_project_id=>20,
  #  :labels=>[],
  #  :work_in_progress=>false,
  #  :milestone=>nil,
  #  :merge_when_pipeline_succeeds=>false,
  #  :merge_status=>"unchecked",
  #  :sha=>"d948b68cd6d821416227d2fb539ee7c70855fb25",
  #  :merge_commit_sha=>nil,
  #  :user_notes_count=>0,
  #  :approvals_before_merge=>nil,
  #  :should_remove_source_branch=>nil,
  #  :force_remove_source_branch=>nil,
  #  :squash=>false,
  #  :web_url=>"https://gitlab.quiqup.com/backend/CoreAPI/merge_requests/1",
  #  :time_stats=>{"time_estimate"=>0, "total_time_spent"=>0, "human_time_estimate"=>nil, "human_total_time_spent"=>nil},
  #  :subscribed=>true}

def merge_request_full_fixture
  load_fixture_yml('gitlab/formatted/merge_request_full.yml')
end

def create_merge_request(project = create_project, info: merge_request_full_fixture)
  merge_request = merge_request_basic_fixture

  project.merge_requests.create!(
    id: merge_request[:id],
    iid: merge_request[:iid],
    title: merge_request[:title],
    description: merge_request[:description],
    state: merge_request[:state],
    web_url: merge_request[:web_url],
    info: info
  )
end


def branch_fixture
  load_fixture_yml('gitlab/formatted/branch.yml')
end

def create_branch(project = create_project)
  branch = branch_fixture

  project.branches.create!(
    id: branch[:id],
    name: branch[:name],
    commit: branch[:commit],
    merged: branch[:merged],
    protected: branch[:protected],
    developers_can_push: branch[:developers_can_push],
    developers_can_merge: branch[:developers_can_merge]
  )
end

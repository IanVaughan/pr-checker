module Gitlab
  class Projects < Access
    LARGE_NUMBER_NEVER_GOING_TO_EXCEED = 2000

    def call
      response_to_array Gitlab.projects(simple: true, per_page: LARGE_NUMBER_NEVER_GOING_TO_EXCEED)
    end
  end
end

# => #<Gitlab::ObjectifiedHash:70106196076860 {hash: {"id"=>297, "description"=>"test-kube", "default_branch"=>"master", "tag_list"=>[], "ssh_url_to_repo"=>"git@gitlab.quiqup.com:maria/my-kube-test.git", "http_url_to_repo"=>"https://gitlab.quiqup.com/maria/my-kube-test.git", "web_url"=>"https://gitlab.quiqup.com/maria/my-kube-test", "name"=>"my-kube-test", "name_with_namespace"=>"Maria Valero / my-kube-test", "path"=>"my-kube-test", "path_with_namespace"=>"maria/my-kube-test", "star_count"=>0, "forks_count"=>0, "created_at"=>"2017-10-31T16:25:14.763Z", "last_activity_at"=>"2017-10-31T16:25:14.763Z"}}
#
# => #<Gitlab::ObjectifiedHash:70106196076060 {hash: {"id"=>295, "description"=>"", "default_branch"=>"master", "tag_list"=>[], "ssh_url_to_repo"=>"git@gitlab.quiqup.com:volker/tfl_streams.git", "http_url_to_repo"=>"https://gitlab.quiqup.com/volker/tfl_streams.git", "web_url"=>"https://gitlab.quiqup.com/volker/tfl_streams", "name"=>"tfl_streams", "name_with_namespace"=>"Volker Rabe / tfl_streams", "path"=>"tfl_streams", "path_with_namespace"=>"volker/tfl_streams", "star_count"=>0, "forks_count"=>0, "created_at"=>"2017-10-30T13:54:43.962Z", "last_activity_at"=>"2017-10-31T17:27:46.228Z"}}

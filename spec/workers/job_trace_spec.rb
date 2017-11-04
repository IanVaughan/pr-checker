require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Workers::JobTrace do
  let(:instance) { described_class.new }
  let(:perform) { instance.perform(project.id, job.id) }

  let!(:project) { create_project }
  let!(:pipeline) { create_pipeline(project) }
  let!(:job) { create_job(pipeline) }

  let(:trace) do
    "\e[0KRunning with gitlab-ci-multi-runner 9.5.1 (96b34cc)\n  on runner-01.quiq.ly (88f66d5b)\n\e[0;m\e[0KUsing Docker executor with image registry.quiqup.com/backend/docker-api-builder:0.0.5 ...\n\e[0;m\e[0KStarting service elasticsearch:2.2.2 ...\n\e[0;m\e[0KPulling docker image elasticsearch:2.2.2 ...\n\e[0;m\e[0KUsing docker image elasticsearch:2.2.2 ID=sha256:c3f0d8455a2fb6441cca423be97b631f59fbd64edf0062681420f9d9af423e12 for elasticsearch service...\n\e[0;m\e[0KStarting service redis:latest ...\n\e[0;m\e[0KPulling docker image redis:latest ...\n\e[0;m\e[0KUsing docker image redis:latest ID=sha256:1fb7b6c8c0d0713640c99dc75f7f39849cb9fc5619c1ba4ff6da286e6af759ee for redis service...\n\e[0;m\e[0KStarting service registry.quiqup.com/backend/docker-test-postgis:latest ...\n\e[0;m\e[0KPulling docker image registry.quiqup.com/backend/docker-test-postgis:latest ...\n\e[0;m\e[0KUsing docker image registry.quiqup.com/backend/docker-test-postgis:latest ID=sha256:f4d3da8ce401ad66107518e1b58c99b29d8f8cc4ba7656a10f75268fec0e59d1 for registry.quiqup.com/backend/docker-test-postgis service...\n\e[0;m\e[0KWaiting for services to be up and running...\n\e[0;m\e[0KUsing docker image sha256:02783e15e0a237ef4781dabeffe146e3ba9279c69ef3d87417898bf26c38affa for predefined container...\n\e[0;m\e[0KPulling docker image registry.quiqup.com/backend/docker-api-builder:0.0.5 ...\n\e[0;m\e[0KUsing docker image registry.quiqup.com/backend/docker-api-builder:0.0.5 ID=sha256:485ccb15d9c15ac3499f14dbdd20d83ce97679777e6e36a5c040c6a20e9736d1 for build container...\n\e[0;mRunning on runner-88f66d5b-project-20-concurrent-2 via runner-02.quiq.ly...\n\e[32;1mFetching changes...\e[0;m\nRemoving codeclimate.json\nHEAD is now at 4db9fc2 [CW-1183] Define relationship between orders and waypoints using STI\nFrom https://gitlab.quiqup.com/backend/CoreAPI\n + 4db9fc2...754dd19 CW-1183-define-relationship-between-orders-and-waypoints -> origin/CW-1183-define-relationship-between-orders-and-waypoints  (forced update)\n\e[32;1mChecking out 754dd191 as CW-1183-define-relationship-between-orders-and-waypoints...\e[0;m\n\e[32;1mSkipping Git submodules setup\e[0;m\n\e[32;1mChecking cache for api-bundle...\e[0;m\n\e[32;1mSuccessfully extracted cache\e[0;m\n\e[32;1m$ SHORT_CI_COMMIT_SHA=$(echo $CI_COMMIT_SHA | cut -c 1-7)\e[0;m\n\e[32;1m$ SLACK_CHANNEL=\"#dev-backend\"\e[0;m\n\e[32;1m$ SLACK_TEXT=\"<$CI_PROJECT_URL/commit/$CI_COMMIT_SHA|$SHORT_CI_COMMIT_SHA> to $CI_ENVIRONMENT_URL\"\e[0;m\n\e[32;1m$ DEPLOYING_TITLE_TEXT=\"[$CI_ENVIRONMENT_SLUG] Deploying CoreAPI\"\e[0;m\n\e[32;1m$ DEPLOYED_TITLE_TEXT=\"[$CI_ENVIRONMENT_SLUG] Deployed CoreAPI\"\e[0;m\n\e[32;1m$ DEPLOYING_BODY_TEXT=\"Deploying ${SLACK_TEXT} | <$CI_PROJECT_URL/pipelines/$CI_PIPELINE_ID|Pipeline $CI_PIPELINE_ID> | $GITLAB_USER_EMAIL\"\e[0;m\n\e[32;1m$ DEPLOYED_BODY_TEXT=\"Deployed $SLACK_TEXT | <http://rancher.quiq.ly:8080/env/1a8/apps/stacks/1st102|Rancher Stack> | $GITLAB_USER_EMAIL\"\e[0;m\n\e[32;1m$ eval $(ssh-agent -s)\e[0;m\nAgent pid 14\n\e[32;1m$ ssh-add <(echo \"$SSH_PRIVATE_KEY\")\e[0;m\nIdentity added: /dev/fd/63 (/dev/fd/63)\n\e[32;1m$ git submodule update --init\e[0;m\n\e[32;1m$ cp config/database.yml.test config/database.yml\e[0;m\n\e[32;1m$ cp config/redis.yml.test config/redis.yml\e[0;m\n\e[32;1m$ bundle install -j $(nproc) --path vendor\e[0;m\nThe git source `git://github.com/brett-richardson/flexible-config.git` uses the `git` protocol, which transmits data without encryption."
  end

  describe '#perform', sidekiq: :fake do
    it "works" do
      expect_any_instance_of(Gitlab::JobTrace).to receive(:call).and_return(trace)

      perform
    end
  end
end

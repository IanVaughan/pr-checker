module Gitlab
  class JobTrace < Access
    def call(path_with_namespace, job_id)
      puts "Gitlab::JobTrace project:#{path_with_namespace}, job:#{job_id}"

      Gitlab.job_trace(path_with_namespace, job_id)
    end
  end
end

module Gitlab
  class Jobs < Access
    def call(project, pipeline)
      puts "Gitlab::Jobs project:#{project["path_with_namespace"]}, pipeline_id:#{pipeline['_id']}"
      pipeline(project["path_with_namespace"], pipeline["_id"])
    end

    private

    def pipeline(path_with_namespace, pipeline_id)
      response_to_array(Gitlab.pipeline_jobs(path_with_namespace, pipeline_id))
    end
  end
end

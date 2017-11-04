module Gitlab
  class Jobs < Access
    def call(project, pipeline_id)
      pipeline(project["path_with_namespace"], pipeline_id)
    end

    private

    def pipeline(path_with_namespace, pipeline_id)
      response_to_array(Gitlab.pipeline_jobs(path_with_namespace, pipeline_id))
    end
  end
end

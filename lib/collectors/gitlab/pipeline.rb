module Gitlab
  class Pipeline < Access
    def call(project, pipeline_id)
      puts "Gitlab::Pipeline project:#{project["path_with_namespace"]}, pipeline_id:#{pipeline_id}"
      pipeline(project["path_with_namespace"], pipeline_id)
    end

    private

    def pipeline(path_with_namespace, pipeline_id)
      response_to_hash(Gitlab.pipeline(path_with_namespace, pipeline_id))
    end
  end
end

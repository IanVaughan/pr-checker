module Gitlab
  class Pipelines < Access
    def call(project)
      # puts "Gitlab::Pipelines:#{project["path_with_namespace"]}"
      pipelines(project["path_with_namespace"])
    end

    private

    def pipelines(path_with_namespace)
      Gitlab.pipelines(path_with_namespace, per_page: 100).map do |pipeline|
        response_to_hash(pipeline)
      end
    end
  end
end

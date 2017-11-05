module Gitlab
  class Pipelines < Access
    def call(project)
      pipelines(project["path_with_namespace"])
    end

    private

    def pipelines(path_with_namespace)
      response_to_array Gitlab.pipelines(path_with_namespace)
      # Gitlab.pipelines(path_with_namespace, per_page: 100, page: page).map do |pipeline|
      #   response_to_hash(pipeline)
      # end
    end
  end
end

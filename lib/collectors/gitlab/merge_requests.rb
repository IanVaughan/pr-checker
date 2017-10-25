module Gitlab
  class MergeRequests < Access
    def call(project)
      puts "Gitlab::MergeRequests:#{project["path_with_namespace"]}"
      response_to_array(merge_requests(project["path_with_namespace"]))
    end

    private

    def merge_requests(path_with_namespace)
      Gitlab.merge_requests(path_with_namespace, state: "opened", per_page: 100)
    end

    # def merge_requests(id)
    #   project = @data[:projects]&.find { |p| p[:id] == id }
    #   project[:merge_requests] unless project.nil?
    # end
  end
end

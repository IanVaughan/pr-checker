module Gitlab
  class MergeRequests < Access
    def call(project, view: 'simple', state: nil)
      response_to_array(merge_requests(project["path_with_namespace"], view, state))
    end

    private

    def merge_requests(path_with_namespace, view, state)
      if state
        Gitlab.merge_requests(path_with_namespace, view: view, state: state)
      else
        Gitlab.merge_requests(path_with_namespace, view: view)
      end
    end

    # def merge_requests(id)
    #   project = @data[:projects]&.find { |p| p[:id] == id }
    #   project[:merge_requests] unless project.nil?
    # end
  end
end

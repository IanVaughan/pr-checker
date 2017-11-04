module Gitlab
  class MergeRequests < Access
    def call(project, page, view: 'simple', state: nil)
      response_to_array(merge_requests(project["path_with_namespace"], page, view, state))
    end

    private

    def merge_requests(path_with_namespace, page, view, state)
      if state
        Gitlab.merge_requests(path_with_namespace, per_page: 100, view: view, page: page, state: state)
      else
        Gitlab.merge_requests(path_with_namespace, per_page: 100, view: view, page: page)
      end
    end

    # def merge_requests(id)
    #   project = @data[:projects]&.find { |p| p[:id] == id }
    #   project[:merge_requests] unless project.nil?
    # end
  end
end

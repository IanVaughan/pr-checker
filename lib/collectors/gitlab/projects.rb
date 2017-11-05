module Gitlab
  class Projects < Access
    def call
      # response_to_array Gitlab.projects(simple: true, per_page: 100, page: page)
      response_to_array Gitlab.projects(simple: true)
    end
  end
end

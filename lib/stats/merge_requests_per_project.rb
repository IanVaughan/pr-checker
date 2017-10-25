module Stats
  class MergeRequestsPerProject
    def call(project)
      {
        name: project[:name_with_namespace],
        total: project[:merge_requests].count,
        opened: project[:merge_requests].select { |m| m[:state] == 'opened' }.count,
        closed: project[:merge_requests].select { |m| m[:state] == 'closed' }.count,
        merged: project[:merge_requests].select { |m| m[:state] == 'merged' }.count,
      }
    end
  end
end

require_relative './stats/average_build_times_per_project'
require_relative './stats/merge_requests_per_project'
require_relative './stats/old_open_merge_requests'

class StatCollector
  # attr_accessor :stats

  STATS = [
    Stats::AverageBuildTimesPerProject.new,
    Stats::MergeRequestsPerProject.new,
    Stats::OldOpenMergeRequests.new
  ]

  def initialize(gitlab_data)
    @data = gitlab_data
    # @stats = {}
  end

  def collect_stats
    STATS.each do |stat|
      # @stats.merge!(stat.call(@data))
      stat.call(@data)
    end
  end
end

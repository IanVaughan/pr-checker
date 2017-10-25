module Stats
  class AverageBuildTimesPerProject
    def call(data)
      res = data[:projects].map do |_, project|
        next if project[:pipelines].count.zero?

        development_build_times = []
        release_build_times = []

        project[:pipelines].each do |_, pipeline|
          next if %w(running failed).include?(pipeline[:status]) || pipeline[:duration].nil?

          if %w(master staging qa).include?(pipeline[:ref])
            release_build_times << pipeline[:duration]
          else
            development_build_times << pipeline[:duration]
          end
        end

        next if release_build_times.size.zero? || development_build_times.size.zero?
        {
          name: project[:name_with_namespace],
          release_average: release_build_times.sum / release_build_times.size.to_f,
          development_average: development_build_times.sum / development_build_times.size.to_f
        }
      end

      {
        averages_per_project: res.compact
      }
    end
  end
end

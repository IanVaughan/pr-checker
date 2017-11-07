module Workers
  class ProjectLabels
    include Sidekiq::Worker

    STANDARD_SET = [
      {
        :name=>"+2d",
        :color=>"#009800",
        :description=>"Has been reviewed, can now merge"
      },{
        :name=>"NO MERGE",
        :color=>"#e11d21",
        :description=>"This must not be merged"
      },{
        :name=>"On Hold",
        :color=>"#44AD8E",
        :description=>"",
      },{
        :name=>"On QA",
        :color=>"#428BCA",
        :description=>nil,
      },{
        :name=>"QA Passed",
        :color=>"#bfe5bf",
        :description=>nil,
      },{
        :name=>"QA Pending",
        :color=>"#eb6420",
        :description=>nil,
      }
      # :name=>"Review",
      # :color=>"#fbca04",
      # :description=>nil,
      #
      # :name=>"WIP",
      # :color=>"#1d76db",
      # :description=>"",
      #
      # :name=>"blocked",
      # :color=>"#f9d0c4",
      # :description=>nil,
      #
      # :name=>"bug",
      # :color=>"#fc2929",
      # :description=>nil,
      #
      # :name=>"enhancement",
      # :color=>"#84b6eb",
      # :description=>nil,
      #
      # :name=>"question",
      # :color=>"#c5def5",
      # :description=>nil,
    ]

    def perform(project_id)
      logger.info "Workers::ProjectLabels project_id:#{project_id}"

      found_lables = Gitlab::Labels.new.call(project_id)
      standard_set = STANDARD_SET

      found_lables.each do |found_label|
        logger.info "Workers::ProjectLabels project_id:#{project_id}, found_label:#{found_label[:name]}"
        standard_label = standard_set.select { |ss| ss[:name] == found_label[:name] }.first
        next unless standard_label.present?

        unless found_label[:color] == standard_label[:color]
          logger.info "Workers::ProjectLabels project_id:#{project_id}, updating label:#{standard_label[:name]}"
          # Gitlab.edit_label(project_id, found_label[:name], color: standard_label[:color])
        end
        standard_set.delete_if { |ss| ss[:name] == found_label[:name] }
      end

      standard_set.each do |standard_label|
        logger.info "Workers::ProjectLabels project_id:#{project_id}, creating label:#{standard_label[:name]}"
        # Gitlab.create_label(project_id, standard_label[:name], standard_label[:color])
      end
      nil
    end
  end
end

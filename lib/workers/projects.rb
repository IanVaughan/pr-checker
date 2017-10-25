module Workers
  class Projects
    include Sidekiq::Worker

    def perform
      puts 'Workers::Projects...'
      projects.each do |raw_project|
        puts 'Workers::Project...'
        project = create_or_update(raw_project)
        Project.perform_async(project.id)
      end
    end

    private

    def projects
      Gitlab::Projects.new.call
    end

    def create_or_update(raw_project)
      project = Models::Project.find(raw_project[:id])

      if project.present?
        project.update_attributes!(raw_project)
      else
        project = Models::Project.new(raw_project)
        project.save!
      end

      project
    end
  end
end

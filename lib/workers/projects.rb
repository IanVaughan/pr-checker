module Workers
  class Projects
    include Sidekiq::Worker

    def perform
      logger.info 'Workers::Projects...'
      projects = Gitlab::Projects.new.call
      logger.info "Workers::Projects count:#{projects.count}"

      projects.each do |raw_project|
        logger.info "Workers::Project project_id:#{raw_project[:id]}"
        project = create_or_update(raw_project)
        Project.perform_async(raw_project[:id])
      end
    end

    private

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

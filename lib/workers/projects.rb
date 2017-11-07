module Workers
  class Projects
    include Sidekiq::Worker

    def perform
      Users.perform_async

      logger.info 'Workers::Projects...'
      projects = Gitlab::Projects.new.call
      logger.info "Workers::Projects count:#{projects.count}"

      projects.each do |raw_project|
        logger.info "Workers::Projects project_id:#{raw_project[:id]}"
        create_or_update(raw_project)
        Project.perform_async(raw_project[:id])
      end
    end

    private

    def create_or_update(raw_project)
      ::Project.find_or_create_by(id: raw_project[:id]).tap do |project|
        project.update!(
          description: raw_project[:description],
          default_branch: raw_project[:default_branch],
          tag_list: raw_project[:tag_list],
          ssh_url_to_repo: raw_project[:ssh_url_to_repo],
          http_url_to_repo: raw_project[:http_url_to_repo],
          web_url: raw_project[:web_url],
          name: raw_project[:name],
          name_with_namespace: raw_project[:name_with_namespace],
          path: raw_project[:path],
          path_with_namespace: raw_project[:path_with_namespace],
          star_count: raw_project[:star_count],
          forks_count: raw_project[:forks_count],
          last_activity_at: raw_project[:last_activity_at],
          info: raw_project
        )
      end
    end
  end
end

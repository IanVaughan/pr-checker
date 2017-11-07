module Workers
  class Users
    include Sidekiq::Worker

    def perform
      logger.info "Workers::Users"

      users = Gitlab::Users.new.call
      users.each do |gitlab_user|
        User.find_or_create_by(id: gitlab_user[:id]).tap do |user|
          user.update!(
            name: gitlab_user[:name],
            email: gitlab_user[:email]
          )
        end
      end
    end
  end
end

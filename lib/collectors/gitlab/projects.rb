module Gitlab
  class Projects < Access
    LARGE_NUMBER_NEVER_GOING_TO_EXCEED = 2000

    def call
      # puts "Collecting projects..."
      response_to_array Gitlab.projects(simple: true, per_page: LARGE_NUMBER_NEVER_GOING_TO_EXCEED)
    end
  end
end

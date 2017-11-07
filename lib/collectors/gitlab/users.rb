module Gitlab
  class Users < Access
    def call
      response_to_array(Gitlab.users)
    end
  end
end

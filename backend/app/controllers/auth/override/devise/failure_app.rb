class Auth::Override::Devise::FailureApp < Devise::FailureApp
    def respond
      self.status = :unauthorized
      self.content_type = "application/json"
    end
end

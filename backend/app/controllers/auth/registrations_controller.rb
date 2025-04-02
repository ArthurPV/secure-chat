# frozen_string_literal: true

class Auth::RegistrationsController < Auth::Override::Devise::RegistrationsController
  skip_before_action :authenticate, only: %i[create]

  # POST /auth/sign_up
  def create
    super do
      if resource.persisted?
        head :no_content
      else
        head :unprocessable_entity
      end

      return
    end
  end
end

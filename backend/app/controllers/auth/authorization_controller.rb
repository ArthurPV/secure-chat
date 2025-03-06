# frozen_string_literal: true

class Auth::AuthorizationController < Auth::Override::Devise::AuthorizationController
  skip_before_action :authenticate, only: %i[create]

  # POST /auth/sign_in
  def create
    super do |resource|
      render json: {
        token: AuthJwt.encode!(resource)
      }

      return
    end
  end

  # DELETE /auth/sign_out
  def destroy
    Current.user_jti.destroy!

    head :success
  end
end

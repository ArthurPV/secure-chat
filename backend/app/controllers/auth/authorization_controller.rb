# frozen_string_literal: true

class Auth::AuthorizationController < Auth::Override::Devise::AuthorizationController
  skip_before_action :authenticate, only: %i[create]
  # https://github.com/heartcombo/devise/blob/fec67f98f26fcd9a79072e4581b1bd40d0c7fa1d/app/controllers/devise/sessions_controller.rb#L6
  skip_before_action :verify_signed_out_user, only: %i[destroy]

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

    head :no_content
  end
end

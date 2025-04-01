# frozen_string_literal: true

class Auth::Override::Devise::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  # DISABLED GET /auth/sign_up
  def new
    head :not_found
  end

  # DISABLED GET /auth/edit
  def edit
    head :not_found
  end

  # DISABLED PUT /auth
  def update
    head :not_found
  end

  # DISABLED DELETE /auth
  def destroy
    head :not_found
  end

  # DISABLED GET /auth/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    head :not_found
  end

  protected

  # The path used after sign up.
  def after_sign_up_path_for(_resource); end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password username phone_number public_key private_key])
  end
end

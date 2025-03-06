# frozen_string_literal: true

class Auth::Override::Devise::AuthorizationController < Devise::SessionsController
  # DISABLED GET /auth/sign_in
  def new
    head :not_found
  end

  protected

  def after_sign_in_path_for(_resource); end
end

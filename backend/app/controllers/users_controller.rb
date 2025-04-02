class UsersController < Users::BaseController
  def show; end

  def update
    if Current.user.update(users_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def users_params
    params.require(:user).permit(:username, :phone_number)
  end
end

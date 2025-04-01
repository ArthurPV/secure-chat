class Users::UploadProfilePicturesController < Users::BaseController
  def update
    if Current.user.update(upload_profile_picture_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    if Current.user.profile_picture.attached?
      Current.user.profile_picture.purge

      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def upload_profile_picture_params
    params.fetch(:user).permit(:profile_picture)
  end
end

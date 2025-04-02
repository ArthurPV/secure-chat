class UserContactsController < Users::BaseController
  def index
    @user_contacts = Current.user.user_contacts
  end
end

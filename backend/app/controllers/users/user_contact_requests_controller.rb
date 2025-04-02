class Users::UserContactRequestsController < Users::BaseController
  include EntityConcern

  before_action :set_entity, only: %i[destroy accept]

  def index
    @user_contact_requests = Current.user.user_contact_requests
  end

  def create
    if UserContactRequest.create(user_contact_requests_params.merge({ user_id: Current.user.id }))
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    if @entity.destroy
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def accept
    contact = UserContact.create!

    UserContacted.create!(user_contact: contact, user: @entity.user)
    UserContacted.create!(user_contact: contact, user: @entity.contacted)
    @entity.destroy!

    head :no_content
  end

  private

  def set_entity
    super(UserContactRequest)
  end

  def user_contact_requests_params
    params.require(:user_contact_request).permit(:contacted_uuid)
  end
end
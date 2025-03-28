# frozen_string_literal: true

class UserConversationsController < UserConversations::BaseController
  def create
    if UserConversation.create(user_conversation_params)
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

  private

  def user_conversation_params
    params.require(:user_conversation).permit(:public_key, :private_key, participants: [])
  end
end

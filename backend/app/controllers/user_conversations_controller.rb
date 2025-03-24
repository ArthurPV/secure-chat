# frozen_string_literal: true

class UserConversationsController < ApplicationController
  def create
    if UserConversation.create(user_conversation_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def user_conversation_params
    allowed_items = %i[public_key private_key] + [ { participants: [] } ]
    params.require(:user_conversation).permit(*allowed_items)
  end
end

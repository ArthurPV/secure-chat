# frozen_string_literal: true

class UserConversationsController < ApplicationController
  include EntityConcern

  before_action :set_entity, only: %i[destroy]

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

  def set_entity
    super(UserConversation)
  end
end

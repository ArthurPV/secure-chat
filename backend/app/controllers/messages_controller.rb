class MessagesController < ApplicationController
  include EntityConcern

  before_action :set_entity, only: %i[show destroy]

  def create
    if Message.create(message_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    if @message.destroy
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def message_params
    allowed_params
      .permit(:content, :conversation_uuid)
      .merge({ user_id: Current.user.id })
  end

  def set_entity
    super(Message)
  end
end

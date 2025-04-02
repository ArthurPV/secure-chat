class MessagesController < ApplicationController
  include EntityConcern

  before_action :set_entity, only: %i[destroy]

  def create
    if Message.create(message_params).valid?
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @message.destroy!

    head :no_content
  end

  private

  def message_params
    params
      .require(:message)
      .permit(:content, :conversation_uuid)
      .merge({ user_id: Current.user.id })
  end

  def set_entity
    super(Message)
  end
end

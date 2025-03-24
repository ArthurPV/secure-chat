class MessagesController < ApplicationController
  include EntityConcern

  before_action :set_entity, only: %i[destroy]

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
    params.require(:message).permit(:content, :conversation)
  end

  def set_entity
    super(Message)
  end
end

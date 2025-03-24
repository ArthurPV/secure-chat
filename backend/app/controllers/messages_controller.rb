class MessagesController < ApplicationController
  def create
    if Message.create(message_params.merge({ from: Current.user.id }))
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    if User.find_by(id: params[:id])&.destroy
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:to, :content)
  end
end

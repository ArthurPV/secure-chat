class UserConversations::BaseController < ApplicationController
  include EntityConcern

  before_action :set_entity, only: %i[destroy]

  private

  def set_entity
    super(UserConversation)
  end
end

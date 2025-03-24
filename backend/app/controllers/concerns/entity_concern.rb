# frozen_string_literal: true

module EntityConcerns
  extend ActiveSupport::Concern

  private

  def set_entity(model)
    @model = model
    @entity = @model.find_by_uuid(params[:uuid])

    head :unprocessable_entity if @entity.nil?
  end
end

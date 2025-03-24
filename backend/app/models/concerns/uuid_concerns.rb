module UuidConcerns
  extend ActiveSupport::Concern

  def initialize(attributes = {})
    super
    self.uuid = SecureRandom.uuid
  end

  class_methods do
    def find_by_uuid(uuid)
      name.constantize.find_by(uuid:)
    end
  end
end

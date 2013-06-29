module Uploadable
  extend ActiveSupport::Concern

  included do
    belongs_to :imageable, polymorphic: true
    mount_uploader :file, ImageUploader
    delegate :regular, to: :file
  end
end

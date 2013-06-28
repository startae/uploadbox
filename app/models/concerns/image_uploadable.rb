module ImageUploadable
  extend ActiveSupport::Concern

  included do
    has_one :image, as: :imageable, dependent: :destroy
  end

  def image?
    image and image.file?
  end
end

module ImageUploadable
  extend ActiveSupport::Concern

  included do
    has_one :image, as: :imageable
  end

  def image?
    image and image.file?
  end
end

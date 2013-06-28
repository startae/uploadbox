class Post < ActiveRecord::Base
  has_one :image, as: :imageable

  def image?
    image and image.file?
  end
end

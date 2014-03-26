class Post < ActiveRecord::Base
  uploads_one :picture, thumb: [100, 100], regular: [300, 200], big: [600, 400], placeholder: 'placeholder.png'

  uploads_many :images, thumb: [90, 90], regular: [200, 200]
end

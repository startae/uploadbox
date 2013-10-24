class Post < ActiveRecord::Base
  uploads_one :picture, thumb: [100, 100], regular: [300, 200], placeholder: 'placeholder.png'
  uploads_many :images, thumb: [50, 50], regular: [200, 200]

end

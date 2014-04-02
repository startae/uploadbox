class Story < ActiveRecord::Base
  uploads_many :images, regular: [700, 600]
end

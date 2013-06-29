class ImageUploader < CarrierWave::Uploader::Base
  include ImageProcessing
end

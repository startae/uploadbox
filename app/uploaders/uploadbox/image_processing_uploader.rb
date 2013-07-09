module Uploadbox
  class ImageProcessingUploader < CarrierWave::Uploader::Base
    include CarrierWave::MimeTypes
    include CarrierWave::MiniMagick
    include CarrierWave::Processing::MiniMagick

    process :set_content_type
    process :strip

    def store_dir
      # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      "uploads/image/#{mounted_as}/#{model.id}"
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end

    def filename
      if original_filename
        extension = File.extname(original_filename)
        name = File.basename(original_filename, extension).parameterize.dasherize
        "#{name}#{extension}"
      end
    end
  end
end

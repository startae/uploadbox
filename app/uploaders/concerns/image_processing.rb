module ImageProcessing
  extend ActiveSupport::Concern

  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick
  include CarrierWave::Processing::MiniMagick

  included do
    process :set_content_type
    process :strip

    version :regular do
      process resize_to_fill: [100, 100]
      process quality: 30
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
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

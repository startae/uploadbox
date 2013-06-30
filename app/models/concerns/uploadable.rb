module Uploadable
  extend ActiveSupport::Concern

  included do
    belongs_to :imageable, polymorphic: true
    after_initialize :mount_custom_uploader
  end

  def mount_custom_uploader(*args)
    imageable = self.imageable_type.constantize
    self.class.instance_eval do
      delegate *imageable.versions.keys, to: :file
      dynamic_uploader = Class.new(Uploadbox::ImageProcessingUploader)
      dynamic_uploader.class_eval do
        imageable.versions.each do |version_name, dimensions|
          if Uploadbox.retina
            dimensions = dimensions.map{ |d| d * 2 }
            quality = Uploadbox.retina_quality || 30
          else
            quality = Uploadbox.image_quality || 70
          end

          version version_name do
            process resize_to_fill: dimensions
            process quality: quality
          end
        end
      end
      mount_uploader :file, dynamic_uploader
    end
  end

  def versions
    self.imageable_type.constantize.versions
  end
end

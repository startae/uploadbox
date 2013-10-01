module Uploadbox
  module ImageUploader
    def uploads_one(upload_name, options={})
      default_options = {
        default: false,
        removable: true,
        retina: Uploadbox.retina,
        quality: Uploadbox.retina ? (Uploadbox.retina_quality || 40) : (Uploadbox.image_quality || 80)
      }
      options = options.reverse_merge(default_options)
      upload_versions = options.select{ |key| default_options.keys.exclude? key }
      options = options.select{ |key| default_options.keys.include? key }

      imageable_type = self.to_s
      upload_class_name = imageable_type + upload_name.to_s.camelize
      upload_class = Class.new(Image)
      Uploadbox.const_set(upload_class_name, upload_class)

      # @post.picture?
      define_method("#{upload_name}?") { send(upload_name) and send(upload_name).file? }

      # @post.attach_picture
      define_method("attach_#{upload_name}") do |upload_id|
        if upload_id.present?
          self.send("attach_#{upload_name}!", upload_id)
        end
      end

      # @post.remote_picture_url=('http://exemple.com/image.jpg')
      define_method("remote_#{upload_name}_url=") do |url|
        upload = Uploadbox.const_get(upload_class_name).create!(remote_file_url: url)
        self.send("#{upload_name}=", upload)
      end

      # @post.attach_picture!
      define_method("attach_#{upload_name}!") do |upload_id|
        self.send("#{upload_name}=", upload_class.find(upload_id))
      end

      # Post.update_picture_versions!
      self.define_singleton_method "update_#{upload_name}_versions!" do
        Uploadbox.const_get(upload_class_name).find_each{|upload| upload.file.recreate_versions!}
      end

      # Uploadbox::PostPicture < Image
      upload_class.define_singleton_method :versions do
        upload_versions
      end

      upload_class.define_singleton_method :removable? do
        options[:removable]
      end

      upload_class.instance_eval do
        delegate *upload_versions.keys, to: :file

        default_scope -> { where(imageable_type: imageable_type).where(upload_name: upload_name.to_s) }

        # Uploabox::PostPictureUploader < UploadBox::ImgProcessing < CarrierWave
        dynamic_uploader = Class.new(Uploadbox::ImageProcessingUploader)
        Uploadbox.const_set(self.class.to_s + upload_name.to_s.camelize + 'Uploader', dynamic_uploader)
        dynamic_uploader.class_eval do
          upload_versions.each do |version_name, dimensions|
            if options[:retina]
              dimensions = dimensions.map{ |d| d * 2 }
            end

            version version_name do
              process resize_to_fill: dimensions
              process quality: quality = options[:quality]
            end

            def dimensions
              model.class.versions[version_name]
            end

            def width
              dimensions[0]
            end

            def height
              dimensions[1]
            end
          end
        end
        mount_uploader :file, dynamic_uploader
      end

      has_one upload_name, as: :imageable, dependent: :destroy, class_name: "Uploadbox::#{self.to_s + upload_name.to_s.camelize}"
    end

  end
end
ActiveRecord::Base.extend Uploadbox::ImageUploader


module Uploadbox
  module ImageUploader
    def uploads_one(upload_name, options={})
      default_options = {
        default: false,
        placeholder: false,
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
      
      unless Uploadbox.const_defined?(upload_class_name)
        Uploadbox.const_set(upload_class_name, upload_class)
      end

      # @post.picture?
      define_method("#{upload_name}?") do 
        upload = send("#{upload_name}_upload")
        upload and upload.file?
      end

      # @post.picture
      define_method(upload_name) do
        upload = send("#{upload_name}_upload")

        if upload
          upload
        else
          image = Struct.new(:url, :width, :height) do
            def to_s
              url
            end
          end

          placeholder = Class.new do
            upload_versions.keys.each do |version|
              define_method(version) do
                width = upload_versions[version][0]
                height = upload_versions[version][1]
                image.new("#{version}_#{options[:placeholder]}", width, height)
              end
            end
          end
          placeholder.new
        end
      end

      # @post.picture=(id)
      define_method("#{upload_name}=") do |upload_id|
        if upload_id.present?
          self.send("#{upload_name}_upload=", upload_class.find(upload_id))
        end
      end

      # @post.remote_picture_url=('http://exemple.com/image.jpg')
      define_method("remote_#{upload_name}_url=") do |url|
        upload = Uploadbox.const_get(upload_class_name).create!(remote_file_url: url)
        self.send("#{upload_name}_upload=", upload)
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
        unless Uplaodbox.const_defined?(self.name.demodulize + 'Uploader')
          Uploadbox.const_set(self.name.demodulize + 'Uploader', dynamic_uploader)
        end
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

      has_one "#{upload_name}_upload".to_sym, as: :imageable, 
                                              class_name: "Uploadbox::#{self.to_s + upload_name.to_s.camelize}", 
                                              autosave: true
      accepts_nested_attributes_for "#{upload_name}_upload".to_sym
    end


    def uploads_many(upload_name, options={})
      default_options = {
        default: false,
        placeholder: false,
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
      
      unless Uploadbox.const_defined?(upload_class_name)
        Uploadbox.const_set(upload_class_name, upload_class)
      end

      # @post.images?
      define_method("#{upload_name}?") do 
        upload = send(upload_name)
        upload and upload.any?
      end

      # @post.images=([id, id])
      define_method("#{upload_name}=") do |ids|
        self.send(upload_name).send('replace', [])
        for id in ids.select(&:present?)
          self.send(upload_name).send('<<', upload_class.find(id))
        end
      end

      # Post.update_images_versions!
      self.define_singleton_method "update_#{upload_name}_versions!" do
        Uploadbox.const_get(upload_class_name).find_each{|upload| upload.file.recreate_versions!}
      end

      # Uploadbox::PostImages < Image
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
        unless Uploadbox.const_defined?(self.name.demodulize + 'Uploader')
          Uploadbox.const_set(self.name.demodulize + 'Uploader', dynamic_uploader)
        end
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

      has_many upload_name, as: :imageable, class_name: "Uploadbox::#{self.to_s + upload_name.to_s.camelize}"
    end

  end
end
ActiveRecord::Base.extend Uploadbox::ImageUploader


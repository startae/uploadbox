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

      Uploadbox.instance_eval {remove_const upload_class_name} if Uploadbox.const_defined?(upload_class_name)
      Uploadbox.const_set(upload_class_name, upload_class)

      # @post.picture?
      define_method("#{upload_name}?") do
        upload = send("#{upload_name}_upload")

        !!(upload and (upload.processing? or upload.file?))
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

            def processing?
              false
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

      # @post.picture=(upload)
      define_method("#{upload_name}=") do |upload_file|
        # deals with ie8 and ie9
        if upload_file.is_a? ActionDispatch::Http::UploadedFile
          upload = upload_class.create(file: upload_file)

          self.send("#{upload_name}_upload=", upload)
        elsif upload_file.present?
          self.send("#{upload_name}_upload=", upload_class.find(upload_file.id))
        end
      end

      # @post.remote_picture_url=('http://exemple.com/image.jpg')
      define_method("remote_#{upload_name}_url=") do |url|
        upload = Uploadbox.const_get(upload_class_name).create!(remote_file_url: url)

        self.send("#{upload_name}_upload=", upload)
      end

      # Post.update_picture_versions!
      self.define_singleton_method "update_#{upload_name}_versions!" do
        Uploadbox.const_get(upload_class_name).find_each{ |upload| upload.file.recreate_versions! if upload.file? }
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

            def processing?
              model.processing?
            end

            def original_file
              model.original_file
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

      Uploadbox.instance_eval {remove_const upload_class_name} if Uploadbox.const_defined?(upload_class_name)
      Uploadbox.const_set(upload_class_name, upload_class)

      # @post.images?
      define_method("#{upload_name}?") do
        upload = send(upload_name)
        upload and upload.any?
      end

      # @post.images=([image, imae])
      define_method("#{upload_name}=") do |uploads|

        # deals with ie8 and ie9
        if uploads[0].is_a? ActionDispatch::Http::UploadedFile
          upload = upload_class.create(file: uploads[0])

          self.send(upload_name).send('<<', upload)
        else
          self.send(upload_name).send('replace', [])

          for upload in uploads.select(&:present?)
            self.send(upload_name).send('<<', upload_class.find(upload.id))
          end
        end
      end

      # @post.add_remote_image_url('http://exemple.com/image.jpg')
      define_method("add_remote_#{upload_name.to_s.singularize}_url") do |url|
        upload = upload_class.create!(remote_file_url: url)
        self.send(upload_name).send('<<', upload)
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

            def processing?
              model.processing?
            end

            def original_file
              model.original_file
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

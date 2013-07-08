module Uploadbox
  module ImageUploader
    def uploads_one(upload_name, versions={})
      has_one upload_name, as: :imageable, dependent: :destroy, class_name: 'Image'
      define_method("#{upload_name}?") { send(upload_name) and send(upload_name).file? }

      self.class.instance_eval do
        define_method('versions') do
          versions
        end
      end
    end
  end
end
ActiveRecord::Base.extend Uploadbox::ImageUploader

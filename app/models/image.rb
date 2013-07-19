class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  def self.create_upload(attributes)
    attributes[:imageable_type].constantize # load class

    upload_class_name = attributes[:imageable_type] + attributes[:upload_name].camelize
    attributes.delete(:upload_name)
    Uploadbox.const_get(upload_class_name).create!(attributes)
  end
end

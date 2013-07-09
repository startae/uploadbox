class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  def self.create_upload(attributes)
    upload_class_name = attributes[:imageable_type] + attributes[:upload_name].camelize
    Uploadbox.const_get(upload_class_name).create!(attributes)
  end
end

require 'slim'
require 'sass-rails'
require 'coffee-rails'
require 'fog'
require 'carrierwave'
require 'carrierwave-processing'
require 'mini_magick'
require 'jbuilder'

module Uploadbox
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path('../../../app/uploaders/concerns', __FILE__)
    isolate_namespace Uploadbox
  end
end

class ActionView::Helpers::FormBuilder
  def image_uploader
    @template.render partial: 'uploadbox/images/uploader', locals: {resource: @object, form: self}
  end
end

module ImageUploadable
  def uploads_one(upload_name, options=nil)
    has_one upload_name, as: :imageable, dependent: :destroy, class_name: 'Image'
    define_method("#{upload_name}?") { send(upload_name) and send(upload_name).file? }
  end
end
ActiveRecord::Base.extend ImageUploadable

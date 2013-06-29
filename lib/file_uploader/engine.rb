require 'slim'
require 'sass-rails'
require 'coffee-rails'
require 'fog'
require 'carrierwave'
require 'carrierwave-processing'
require 'mini_magick'
require 'jbuilder'


module FileUploader
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path('../../../app/uploaders/concerns', __FILE__)
    p config.autoload_paths
    isolate_namespace FileUploader
  end
end

class ActionView::Helpers::FormBuilder
  def image_uploader
    @template.render partial: 'file_uploader/images/uploader', locals: {resource: @object, form: self}
  end
end

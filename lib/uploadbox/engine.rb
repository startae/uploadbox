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

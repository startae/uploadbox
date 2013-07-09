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
    initializer 'uploadbox.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Uploadbox::ImgHelper
      end
    end
    isolate_namespace Uploadbox
  end
end

class ActionView::Helpers::FormBuilder
  def uploader(upload_name, options={})
    upload_model_class = "Uploadbox::#{@object.class.to_s + upload_name.to_s.camelize}".constantize
    options.reverse_merge!(preview: upload_model_class.versions.keys.first)
    dimensions = upload_model_class.versions[options[:preview]]
    @template.render partial: 'uploadbox/images/uploader', locals: {
      upload_name: upload_name,
      resource: @object,
      form: self,
      version: options[:preview],
      width: dimensions[0],
      height: dimensions[1]
    }
  end
end

require 'uploadbox/image_uploader'

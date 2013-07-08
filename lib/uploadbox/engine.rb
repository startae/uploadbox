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
  def image_uploader(options={})
    options.reverse_merge!(preview: @object.class.versions.keys.first)
    @template.render partial: 'uploadbox/images/uploader', locals: {resource: @object, form: self, preview: options[:preview]}
  end
end



require 'uploadbox/image_uploader'

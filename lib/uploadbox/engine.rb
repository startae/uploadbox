require 'slim'
require 'sass-rails'
require 'coffee-rails'
require 'fog'
require 'carrierwave'
require 'carrierwave-processing'
require 'mini_magick'
require 'jbuilder'
require 'resque'
require 'heroku_resque_auto_scale'
require 'dotenv-rails'

# Allows redirects from https to http as facebook does
module OpenURI
  def self.redirectable?(uri1,uri2)
    uri1.scheme.downcase == uri2.scheme.downcase || (/\A(?:https?|ftp)\z/i =~ uri1.scheme && /\A(?:https?|ftp)\z/i =~ uri2.scheme)
  end
end

module Uploadbox
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework :rspec, fixture: false, view_specs: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer 'uploadbox.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Uploadbox::ImgHelper
      end
    end
    isolate_namespace Uploadbox
  end
end

class ActionView::Helpers::FormBuilder
  def uploads_one(upload_name, options={})
    upload_model_class = "Uploadbox::#{@object.class.to_s + upload_name.to_s.camelize}".constantize
    options.reverse_merge!(preview: upload_model_class.versions.keys.first,
                           namespace: false,
                           default: false,
                           update_label: 'Alterar',
                           choose_label: 'Escolher',
                           destroy_label: '&times;'.html_safe)
    dimensions = upload_model_class.versions[options[:preview]]
    @template.render partial: 'uploadbox/images/uploads_one', locals: {
      upload_name: upload_name,
      resource: @object,
      form: self,
      version: options[:preview],
      width: dimensions[0],
      height: dimensions[1],
      namespace: options[:namespace],
      default: options[:default],
      removable: upload_model_class.removable?,
      update_label: options[:update_label],
      choose_label: options[:choose_label],
      destroy_label: options[:destroy_label]
    }
  end

  def uploads_many(upload_name, options={})
    upload_model_class = "Uploadbox::#{@object.class.to_s + upload_name.to_s.camelize}".constantize
    options.reverse_merge!(preview: upload_model_class.versions.keys.first,
                           namespace: false,
                           default: false,
                           update_label: 'Alterar',
                           choose_label: 'Escolher',
                           destroy_label: '&times;'.html_safe)
    dimensions = upload_model_class.versions[options[:preview]]
    @template.render partial: 'uploadbox/images/uploads_many', locals: {
      upload_name: upload_name,
      resource: @object,
      form: self,
      version: options[:preview],
      width: dimensions[0],
      height: dimensions[1],
      namespace: options[:namespace],
      default: options[:default],
      removable: upload_model_class.removable?,
      update_label: options[:update_label],
      choose_label: options[:choose_label],
      destroy_label: options[:destroy_label]
    }
  end
end

require 'uploadbox/image_uploader'
module FileUploader
  class Engine < ::Rails::Engine
    isolate_namespace FileUploader
  end
end

class ActionView::Helpers::FormBuilder
  def image_uploader
    @template.render partial: 'file_uploader/images/uploader', locals: {resource: @object, form: self}
  end
end

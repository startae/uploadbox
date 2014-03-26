module Uploadbox
  class ImagesController < ApplicationController
    layout false

    def create
      attributes = image_params
      attributes["imageable_type"].constantize # load class
      attributes["original_file"] = attributes["remote_file_url"]

      attributes.delete("upload_name")
      attributes.delete("remote_file_url")

      upload = Uploadbox.const_get(upload_class_name).create!(attributes)

      if Uploadbox.background_processing
        Resque.enqueue(ProcessImage, {id: upload.id, upload_class_name: upload_class_name})
      else
        upload.process
      end

      render nothing: true
    end

    def find
      # binding.pry
      image_params["imageable_type"].constantize # load class

      @image = Uploadbox.const_get(upload_class_name).find_by(secure_random: image_params[:secure_random])
    end

    def destroy
      render json: Image.find(params[:id]).destroy
    end

    private
      def image_params
        params.require(:image).permit(:remote_file_url, :imageable_type, :upload_name, :secure_random)
      end

      def upload_class_name
        image_params["imageable_type"] + image_params["upload_name"].camelize
      end
  end
end

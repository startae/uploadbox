module Uploadbox
  class ImagesController < ApplicationController
    layout false

    def create
      Resque.enqueue(ProcessImage, image_params)
      # @image = Image.create_upload(image_params)
      p '*' * 100
      p 'Resque.enqueue'
      render nothing: true
    end

    def destroy
      render json: Image.find(params[:id]).destroy
    end

    private
      def image_params
        params.require(:image).permit(:remote_file_url, :imageable_type, :upload_name)
      end
  end
end

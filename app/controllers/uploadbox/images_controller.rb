module Uploadbox
  class ImagesController < ApplicationController
    def create
      @image = Image.create_upload(image_params)
    end

    def update
      @image = Image.create_upload(image_params)
    end

    def destroy
      render json: Image.find(params[:id]).destroy
    end

    private
      def image_params
        params.require(:image).permit(:file, :imageable_type, :upload_name)
      end
  end
end

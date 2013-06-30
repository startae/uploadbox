module Uploadbox
  module ImgHelper
    def img(*args)
      upload = args[0]
      if upload.is_a? CarrierWave::Uploader::Base
        image_tag(upload.url, width: upload.width, height: upload.height)
      else
        image_tag(*args)
      end
    end
  end
end

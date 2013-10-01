class ProcessImage
  extend HerokuResqueAutoScale
  
  @queue = :process_image

  def self.perform(image_params)
    Image.create_upload(image_params)
  end
end
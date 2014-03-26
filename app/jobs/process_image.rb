class ProcessImage
  extend HerokuResqueAutoScale

  @queue = :process_image

  def self.perform(attributes)
    Uploadbox.const_get(attributes['upload_class_name']).find(attributes['id']).process
  end
end
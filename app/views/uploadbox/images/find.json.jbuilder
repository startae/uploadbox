if @image
  json.(@image, :id)
  json.versions do
    @image.class.versions.keys.each do |version|
      json.set! version, @image.send(version).url
    end
  end
  json.url image_path(@image)
end
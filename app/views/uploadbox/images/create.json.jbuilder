json.(@image, :id)
json.versions do
  @image.versions.keys.each do |version|
    json.set! version, @image.send(version).url
  end
end
json.url image_path(@image)

json.(@image, :id)
json.versions do
  json.original @image.file.url
  json.regular @image.file.regular.url
end
json.url image_path(@image)

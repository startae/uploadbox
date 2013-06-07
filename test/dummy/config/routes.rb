Rails.application.routes.draw do

  mount FileUploader::Engine => "/file_uploader"
end

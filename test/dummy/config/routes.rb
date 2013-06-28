Rails.application.routes.draw do
  resources :posts
  root 'posts#index'

  mount FileUploader::Engine => '/file_uploader', as: :file_uploader
end

Rails.application.routes.draw do
  resources :posts
  resources :images, only: [:create, :update, :destroy]
  root 'posts#index'
  mount FileUploader::Engine => '/file_uploader'
end

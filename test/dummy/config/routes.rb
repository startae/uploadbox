Rails.application.routes.draw do
  resources :posts
  root 'posts#index'

  mount Uploadbox::Engine => '/uploadbox', as: :uploadbox
end

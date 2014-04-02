Rails.application.routes.draw do
  resources :stories
  resources :posts
  root 'home#index'

  mount Uploadbox::Engine => '/uploadbox', as: :uploadbox
end

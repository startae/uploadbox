require 'resque/server'
Uploadbox::Engine.routes.draw do
  resources :images, only: [:create, :update, :destroy]
  get 's3/signed_url'
  post 's3/callback'
  mount Resque::Server.new, :at => "/resque"
end

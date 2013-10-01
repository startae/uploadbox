require 'resque/server'
Uploadbox::Engine.routes.draw do
  resources :images, only: [:create, :update, :destroy] do
    get 'find', on: :collection
  end
  mount Resque::Server.new, :at => "/resque"
end

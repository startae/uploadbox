require 'spec_helper'

describe Uploadbox::ImagesController do
  routes { Uploadbox::Engine.routes }

  describe 'create' do
    it 'creates image' do
      picture_file = File.open('spec/support/images/picture.jpg')
      post :create, image: {upload_name: 'picture', file: picture_file, imageable_type: 'Post'}, format: :json
    end
  end

  describe 'update'
  describe 'destroy'
end

require 'spec_helper'

describe Uploadbox::ImagesController do
  routes { Uploadbox::Engine.routes }

  let(:picture_file) { File.open('spec/support/images/picture.jpg') }

  describe 'create' do
    it 'creates image' do
      post :create, image: { upload_name: 'picture', file: picture_file, imageable_type: 'Post'}, format: :json

      expect(Image.count).to eq 1

      expect(Uploadbox.const_get('PostPicture').count).to eq 1
    end
  end

  describe 'destroy' do
    let!(:picture) { Image.create(upload_name: 'picture', file: picture_file, imageable_type: 'Post') }

    it 'destroys image' do
      delete :destroy, id: picture.id, format: :json

      expect(Image.count).to eq 0

      expect(Uploadbox.const_get('PostPicture').count).to eq 0
    end
  end
end

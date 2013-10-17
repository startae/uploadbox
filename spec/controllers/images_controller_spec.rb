require 'spec_helper'

describe Uploadbox::ImagesController do
  routes { Uploadbox::Engine.routes }
  let(:picture_file) { File.open('spec/support/images/picture.jpg') }

  describe 'create' do
    it 'creates image' do
      post :create, image: {'upload_name' => 'picture', 'file' => picture_file, 'imageable_type' => 'Post'}, format: :json
      Image.count.should == 1
      Uploadbox::PostPicture.count.should == 1
    end
  end

  describe 'destroy' do
    let!(:picture) { Image.create_upload('upload_name' => 'picture', 'file' => picture_file, 'imageable_type' => 'Post') }

    it 'destroys image' do
      delete :destroy, id: picture.id, format: :json
      Image.count.should == 0
      Uploadbox::PostPicture.count.should == 0
    end
  end
end

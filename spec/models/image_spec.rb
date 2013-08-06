require 'spec_helper'

describe 'Image Upload' do
  before do
    sham_rack_app = ShamRack.at('www.example.com').stub
    sham_rack_app.register_resource('/picture.jpg', File.read('spec/support/images/picture.jpg'), 'image/jpg')
  end

  after do
    ShamRack.unmount_all
  end

  let(:picture_file) { File.open('spec/support/images/picture.jpg') }
  let(:picture) { Image.create_upload(upload_name: 'picture', file: picture_file, imageable_type: 'Post') }
  let(:post) { Post.create(title: 'Lorem') }

  it 'attach upload by id' do
    post.attach_picture(picture.id)
    Post.first.picture.should == picture
  end

  describe '#remote_image_url' do
    it 'create upload' do
      post = Post.new
      post.remote_picture_url = 'http://www.example.com/picture.jpg'
      post.picture.regular.url.should be_a String
    end
  end
end

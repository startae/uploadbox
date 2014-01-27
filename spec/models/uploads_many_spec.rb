require 'spec_helper'

describe '.uploads_many :images' do
  before do
    sham_rack_app = ShamRack.at('www.example.com').stub
    sham_rack_app.register_resource('/picture.jpg', File.read('spec/support/images/picture.jpg'), 'image/jpg')
  end

  after do
    ShamRack.unmount_all
  end

  let(:picture_file) { File.open('spec/support/images/picture.jpg') }
  let(:img1) { Image.create_upload('upload_name' => 'images', 'file' => picture_file, 'imageable_type' => 'Post') }
  let(:img2) { Image.create_upload('upload_name' => 'images', 'file' => picture_file, 'imageable_type' => 'Post') }
  let(:post) { Post.create(title: 'Lorem') }

  describe 'images attribute' do
    it 'works with #update' do
      post.update(images: [img1, img2])
      post.images.should == [img1, img2]
    end

    it 'works as setter and getter' do
      post.images = [img1, img2]
      post.images.should == [img1, img2]
    end

    it 'works as boolean' do
      post.images?.should eql false
      post.images = [img1]
      post.images?.should == true
    end
  end

  describe '#add_remote_image_url("http://exemple.com/picture.jpg")' do
    it 'creates upload' do
      post.images?.should eql false
      post = Post.new
      post.add_remote_image_url('http://www.example.com/picture.jpg')
      post.images?.should == true
    end
  end
end
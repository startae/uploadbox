require 'spec_helper'

describe '.uploads_one :picture' do
  before do
    sham_rack_app = ShamRack.at('www.example.com').stub
    sham_rack_app.register_resource('/picture.jpg', File.read('spec/support/images/picture.jpg'), 'image/jpg')
  end

  after do
    ShamRack.unmount_all
  end

  let(:picture_file) { File.open('spec/support/images/picture.jpg') }
  let(:picture) { Image.create(upload_name: 'picture', file: picture_file, imageable_type: 'Post') }
  let(:post) { Post.create(title: 'Lorem') }
  let(:post_picture) { Uploadbox.const_get('PostPicture').find(picture.id) }

  describe 'picture attribute' do
    it 'works with #update' do
      post.update(picture: picture)

      expect(post.picture).to eq post_picture
    end

    it 'works with setter' do
      post.picture = picture

      expect(post.picture).to eq post_picture
    end

    it 'works as boolean' do
      expect(post.picture?).to be_falsy

      post.picture = picture

      expect(post.picture?).to be_truthy
    end
  end

  describe '#remote_picture_url=("http://exemple.com/picture.jpg")' do
    it 'creates upload' do
      post = Post.new
      post.picture?.should eql false
      post.remote_picture_url = 'http://www.example.com/picture.jpg'
      post.picture?.should == true
    end
  end
end

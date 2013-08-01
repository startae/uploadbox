require 'spec_helper'

describe 'Image Upload' do
  let(:picture_file) { File.open('spec/support/images/picture.jpg') }

  it 'attach upload by id' do
    picture = Image.create_upload(upload_name: 'picture', file: picture_file, imageable_type: 'Post')
    Image.count.should == 1
    Uploadbox::PostPicture.count.should == 1

    post = Post.create(title: 'Lorem')
    post.attach_picture(picture.id)
    Post.first.picture.should == picture
  end
end

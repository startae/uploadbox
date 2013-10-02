[![Code Climate](https://codeclimate.com/github/startae/uploadbox.png)](https://codeclimate.com/github/startae/uploadbox)

# Do not use (not yet released)

## Installation

Add to Gemfile
```
gem 'uploadbox'
```

Run generators
```
rails g uploadbox:image
```

Add jquery and uploadbox to `application.js`
```
//= require jquery
//= require jquery_ujs
//= require uploadbox
```

Add uploadbox to `application.css`
```
/*
 *= require uploadbox
 */
```

Migrate database
```
rake db:migrate
```

Create a bucket on S3 (US region)

Set environmet variables
```
S3_KEY=AAAA123BBBB
S3_SECRET=abc123ABcEffgee122
S3_REGION=sa-east-1
S3_BUCKET=uploads
```

## Usage
Add `uploads_one` to your model
```
class Post < ActiveRecord::Base
  uploads_one :picture, thumb: [100, 100], regular: [600, 300]
end
```

Add field to form
```
<%= f.uploader :picture %>
```

Attach upload on controller
```
@post.attach_picture(params[:picture_id])
```

Show image
```
<%= img @post.picture.regular if @post.picture? %>
```

## Recreate versions
You might come to a situation where you want to retroactively change a version or add a new one. You can use the `update_#{upload_name}_versions!` method to recreate the versions from the base file.
For a post with a picture:

```
Post.update_picture_versions!
```


## Heroku
Set environmet variables
```
HEROKU_API_KEY=ab12acvc12
HEROKU_APP=your-app-name
```

Add Redis to Go addon
```
heroku addons:add redistogo:nano
```
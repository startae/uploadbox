# Do not use (not yet released)

## Installation

Add to Gemfile
`gem 'uploadbox'`

Run generators
`rails g uploadbox:image`

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
`rake db:migrate`

Update `routes.rb`
`mount Uploadbox::Engine => '/uploadbox', as: :uploadbox`

## Usage
Add `uploads_one` to your model
`uploads_one :picture, thumb: [100, 100], regular: [300, 200]`

Add field to form
`<%= f.uploader :picture %>`

Attach upload on controller
`@post.attach_picture(params[:picture_id])`

Show image
`<%= img @post.picture.regular if @post.picture? %>`

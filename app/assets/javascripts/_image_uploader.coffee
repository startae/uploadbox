class @ImageUploader
  constructor: (@container) ->
    @preview = @container.find('[data-provides="fileupload"]')
    @fileInput = @container.find('input[type="file"]')
    @typeInput = @container.find('input[name="image[imageable_type]"]')
    @uploadNameInput = @container.find('input[name="image[upload_name]"]')
    @idInput = @container.find('[data-item="id"]')
    @container.find('a.btn.fileupload-exists').bind('ajax:success', @delete)
    @thumbContainer = @container.find('.fileupload-preview.thumbnail')
    @fileInput.fileupload
      type: 'POST'
      autoUpload: true
      formData: @getFormData
      add: @add
      progress: @progress
      done: @done

  add: (e, data) =>
    $.ajax
      url: '/uploadbox/s3/signed_url'
      type: 'GET'
      dataType: 'json'
      data:
        doc:
          title: data.files[0].name
      async: false
      success: @signUrlSuccess

    @loader = $('<div class="progress progress-striped active"><div class="bar" style="width: 0%;"></div></div>').hide()
    @preview.prepend(@loader.fadeIn())
    data.submit()

  getFormData: =>
    [
      {name: @container.find('input[name="key"]').attr('name'), value: @container.find('input[name="key"]').val()},
      {name: @container.find('input[name="AWSAccessKeyId"]').attr('name'), value: @container.find('input[name="AWSAccessKeyId"]').val()},
      {name: @container.find('input[name="acl"]').attr('name'), value: @container.find('input[name="acl"]').val()},
      {name: @container.find('input[name="policy"]').attr('name'), value: @container.find('input[name="policy"]').val()},
      {name: @container.find('input[name="signature"]').attr('name'), value: @container.find('input[name="signature"]').val()},
      {name: @container.find('input[name="success_action_status"]').attr('name'), value: @container.find('input[name="success_action_status"]').val()}
      {name: 'file', value: @fileInput.val()}
    ]

  signUrlSuccess: (data) =>
    @container.find('input[name="key"]').val(data.key)
    @container.find('input[name="policy"]').val(data.policy)
    @container.find('input[name="signature"]').val(data.signature)

  progress: (e, data) =>
    progress = parseInt(data.loaded / data.total * 100, 10)
    @loader.find('.bar').css({width: progress + '%'})

  done: (e, data) =>
    console.log @fileInput
    $.ajax
      type: 'POST'
      url: @fileInput.data('callback-url')
      data: 
        'image[remote_file_url]': $(data.result).find('Location').text()
        'image[imageable_type]': @typeInput.val()
        'image[upload_name]': @uploadNameInput.val()

  delete: =>
    @idInput.val('')
    @container.find('.fileupload-preview.thumbnail img').detach()
    @container.find('.fileupload').addClass('fileupload-new').removeClass('fileupload-exists')

  success: (data) =>
    # Here we get the file url on s3 in an xml doc
    url = $(data).find('Location').text()
    # $('#real_file_url').val(url) # Update the real input in the other form

  fail: (e, data) =>
    console.log('fail')

  showThumb: (data) =>
    image = data.result
    @loader.detach()
    @idInput.val(image.id)
    @container.find('a.btn.fileupload-exists').attr('href', image.url)
    @thumbContainer.find('img').detach()
    img = $('<img/>')
    img.attr('src', image.versions[@thumbContainer.data('version')])
    img.attr('width', @thumbContainer.data('width'))
    img.attr('height', @thumbContainer.data('height'))
    @container.find('.fileupload-preview.thumbnail').append(img)
    @container.find('.fileupload').removeClass('fileupload-new').addClass('fileupload-exists')


$ ->
  $('[data-component="ImageUploader"]').each (i, el) ->
    $(el).data('image_uploader', new ImageUploader($(el)))


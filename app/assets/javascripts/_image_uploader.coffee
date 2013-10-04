class @ImageUploader
  constructor: (@container) ->
    @preview = @container.find('[data-provides="fileupload"]')
    @fileInput = @container.find('input[type="file"]')
    @typeInput = @container.find('input[name="image[imageable_type]"]')
    @uploadNameInput = @container.find('input[name="image[upload_name]"]')
    @idInput = @container.find('[data-item="id"]')
    @container.find('a.btn.fileupload-exists').bind('ajax:success', @delete)
    @thumbContainer = @container.find('.fileupload-preview.thumbnail')
    
    @fileInput.show()

    @fileInput.fileupload
      type: 'POST'
      dataType: 'xml'
      replaceFileInput: false
      autoUpload: true
      formData: @getFormData
      dropZone: @container
      pasteZone: @container
      add: @add
      progress: @progress
      done: @done

  add: (e, data) =>
    @file = data.files[0]

    if @loader
      @loader.detach()
    
    if @verifyProcessingInterval
      clearInterval(@verifyProcessingInterval)

    if @file.type.match /gif|jpe?g|png/
      @loader = $('<div class="progress progress-striped active"><div class="bar" style="width: 0%;"></div></div>').hide()
      @preview.prepend(@loader.fadeIn())
      data.submit()

  getFormData: (arg) =>
    file = @file
    @filePath = @container.find('input[name="key"]').val() + file.name
    [
      { name: 'key', value: @filePath },
      { name: 'acl', value: @container.find('input[name="acl"]').val()  },
      { name: 'Content-Type', value: file.type },
      { name: 'AWSAccessKeyId', value: @container.find('input[name="AWSAccessKeyId"]').val() },
      { name: 'policy', value: @container.find('input[name="policy"]').val() },
      { name: 'signature', value: @container.find('input[name="signature"]').val() },
      { name: "file", value: file }
    ]

  progress: (e, data) =>
    progress = parseInt(data.loaded / data.total * 100, 10)
    @loader.find('.bar').css({width: progress + '%'})

  done: (e, data) =>
    $.ajax
      type: 'POST'
      url: @fileInput.data('callback-url')
      data: 
        'image[remote_file_url]': @fileInput.data('url') + @filePath
        'image[imageable_type]': @typeInput.val()
        'image[upload_name]': @uploadNameInput.val()
        'image[secure_random]': @fileInput.data('secure-random')
      complete: =>
        @verifyProcessingInterval = setInterval(@verifyProcessing, 5000)

  verifyProcessing: =>
    arr = @filePath.split('/')
    filename = arr[arr.length - 1]
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: @fileInput.data('find-url')
      data:
        'name': filename
        'imageable_type': @typeInput.val()
        'upload_name': @uploadNameInput.val()
        'secure_random': @fileInput.data('secure-random')

      complete: (data) =>
        if data.responseJSON.hasOwnProperty('id')
          clearInterval(@verifyProcessingInterval)
          @showThumb(data.responseJSON)
        
  delete: =>
    @idInput.val('')
    @container.find('.fileupload-preview.thumbnail img').detach()
    @container.find('.fileupload').addClass('fileupload-new').removeClass('fileupload-exists')

  fail: (e, data) =>
    console.log('fail')

  showThumb: (image) =>
    @loader.detach()
    @idInput.val(image.id)
    @container.find('a.btn.fileupload-exists').attr('href', image.url)
    @thumbContainer.find('img').detach()
    img = $('<img/>')
    img.attr('src', image.versions[@thumbContainer.data('version')])
    img.attr('width', @thumbContainer.data('width'))
    img.attr('height', @thumbContainer.data('height')).hide()
    @container.find('.fileupload-preview.thumbnail').append(img.fadeIn())
    @container.find('.fileupload').removeClass('fileupload-new').addClass('fileupload-exists')


$ ->
  $('[data-component="ImageUploader"]').each (i, el) ->
    $(el).data('image_uploader', new ImageUploader($(el)))

class @UploaderPreview
  constructor: (@container, @file) ->
    @loader = $('<div class="progress progress-striped active"><div class="bar" style="width: 0%;"></div></div>').hide()

    @startLoader() if @isUploadStarting()
      
    @container.find('a.btn.fileupload-exists').bind('ajax:success', @delete)

    @container.find('input[type="file"]:first').show().fileupload
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
      fail: @fail

    @fileInput = @container.find('input[type="file"]')
    @typeInput = @container.find('input[name="image[imageable_type]"]')
    @uploadNameInput = @container.find('input[name="image[upload_name]"]')
    @idInput = @container.find('[data-item="id"]')
    @thumbContainer = @container.find('.fileupload-preview.thumbnail')

  startLoader: =>
    @container.prepend(@loader.fadeIn())
    @container.find('.fileupload').removeClass('processing').addClass('uploading')


  add: (e, data) =>
    @file = data.files[0]

    if @loader
      @loader.detach()
    
    if @verifyProcessingInterval
      clearInterval(@verifyProcessingInterval)

    if @file.type.match /gif|jpe?g|png/
      data.context = @id()
      @startLoader()
      @container.closest('form').find('[type=submit]').attr("disabled", true)
      data.submit()

  getFormData: =>
    @filePath = "uploads/#{@id()}/" + @file.name
    
    [
      { name: 'key', value: @filePath },
      { name: 'acl', value: @container.find('input[name="acl"]').val()  },
      { name: 'Content-Type', value: @file.type },
      { name: 'AWSAccessKeyId', value: @container.find('input[name="AWSAccessKeyId"]').val() },
      { name: 'policy', value: @container.find('input[name="policy"]').val() },
      { name: 'signature', value: @container.find('input[name="signature"]').val() },
      { name: 'file', value: @file }
    ]

  
  isUploadStarting: =>
    @container.find('.fileupload').hasClass('fileupload-new')

  id: =>
    @_id ||= uuid.v4()

  progress: (data) =>
    progress = parseInt(data.loaded / data.total * 100, 10)
    @loader.find('.bar').css({width: progress + '%'})

  done: (data) =>
    @container.find('.fileupload').removeClass('uploading').addClass('processing')
    $.ajax
      type: 'POST'
      url: @fileInput.data('callback-url')
      data: 
        'image[remote_file_url]': @fileInput.data('url') + @filePath
        'image[imageable_type]': @typeInput.val()
        'image[upload_name]': @uploadNameInput.val()
        'image[secure_random]': @id()
      
      complete: =>
        @verifyProcessingInterval = setInterval(@verifyProcessing, 5000)
      
      error: =>
        @loader.detach()
        @container.find('.fileupload').removeClass('uploading').removeClass('processing')
        @container.closest('form').find('[type=submit]').attr("disabled", false)

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
        'secure_random': @id()

      complete: (data) =>
        if data.responseJSON.hasOwnProperty('id')
          clearInterval(@verifyProcessingInterval)
          @showThumb(data.responseJSON)
      
      error: =>
        @loader.detach()
        @container.detach()

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
    @container.find('.fileupload').removeClass('uploading').removeClass('processing')
    @container.closest('form').find('[type=submit]').attr("disabled", false)

  fail: =>
    @loader.detach()
    @container.detach()

  delete: =>
    @idInput.val('')
    @container.detach()


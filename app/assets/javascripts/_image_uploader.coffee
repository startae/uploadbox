class @ImageUploader
  constructor: (@container) ->
    @preview = @container.find('[data-provides="fileupload"]')
    @fileInput = @container.find('input[type="file"]')
    @typeInput = @container.find('input[name="image[imageable_type]"]')
    @uploadNameInput = @container.find('input[name="image[upload_name]"]')
    @idInput = @container.find('[data-item="id"]')
    @container.find('a.btn.fileupload-exists').bind('ajax:success', @delete)
    @thumbContainer = @container.find('.fileupload-preview.preview')

    @setupLabel()

    @fileInput.show()


    @fileInput.fileupload
      type: 'POST'
      dataType: 'xml'
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

    if @file.type and @file.type.match /gif|jpe?g|png/
      loadImage @file, @appendThumb, {
        maxWidth: @thumbContainer.data('width'),
        maxHeight: @thumbContainer.data('height'),
        minWidth: @thumbContainer.data('width'),
        minHeight: @thumbContainer.data('height'),
        canvas: true,
        crop: true,
        orientation: true
      }

      @loader = $('<div><div class="progress progress-striped active"><div class="bar" style="width: 0%;"></div></div><div class="uploader-overlay"></div></div>').hide()
      @loader.find('.uploader-overlay').height(@thumbContainer.data('height'))
      @preview.prepend(@loader)
      @loader.show()

      data.submit()
      @container.find('.fileupload').removeClass('processing').addClass('uploading')
      @container.closest('form').find('[type=submit]').attr("disabled", true)

  appendThumb: (img) =>
    @thumbContainer.html('')
    $(img).hide()
    @container.find('.fileupload-preview.preview').append($(img).show())
    @container.find('.fileupload').removeClass('fileupload-new').addClass('fileupload-uploading')
    @loader.show()

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
    @container.find('.fileupload').removeClass('uploading').addClass('processing')

    $.ajax
      type: 'POST'
      url: @fileInput.data('callback-url')
      data:
        'image[remote_file_url]': @fileInput.data('url') + @filePath
        'image[imageable_type]': @typeInput.val()
        'image[upload_name]': @uploadNameInput.val()
        'image[secure_random]': @fileInput.data('secure-random')

      complete: =>
        @verifyProcessingInterval = setInterval(@verifyProcessing, 500)

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
        image:
          'imageable_type': @typeInput.val()
          'upload_name': @uploadNameInput.val()
          'secure_random': @fileInput.data('secure-random')

      complete: (data) =>
        if data.responseJSON.hasOwnProperty('id')
          clearInterval(@verifyProcessingInterval)
          @showThumb(data.responseJSON)

      error: =>
        @loader.detach()
        @container.find('.fileupload').removeClass('uploading').removeClass('processing')
        @container.closest('form').find('[type=submit]').attr("disabled", false)


  delete: =>
    @idInput.val('')
    @container.find('.fileupload-preview.preview img').detach()
    @container.find('.fileupload').addClass('fileupload-new').removeClass('fileupload-exists')

  fail: (e, data) =>
    @loader.detach()
    @container.find('.fileupload').removeClass('uploading').removeClass('processing')
    @container.closest('form').find('[type=submit]').attr("disabled", false)

  showThumb: (image) =>
    @loader.fadeOut =>
      @loader.detach()
    @idInput.val(image.id)
    @container.find('a.btn.fileupload-exists').attr('href', image.url)
    @thumbContainer.find('img').detach()
    @container.find('.fileupload').removeClass('fileupload-new').addClass('fileupload-exists')
    @container.find('.fileupload').removeClass('uploading').removeClass('processing')
    @container.closest('form').find('[type=submit]').attr("disabled", false)

  setupLabel: =>
    labels = @container.find('.fileupload-actions .fileupload-new, .fileupload-actions .fileupload-exists')
    labels.each (index, label) ->
      $(label).css({marginLeft: $(label).outerWidth() * -0.5, marginTop: $(label).outerHeight() * -0.5})


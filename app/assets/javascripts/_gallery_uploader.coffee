class @GalleryUploader
  constructor: (@container) ->
    @previews = {}

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

  add: (e, data) =>
    if @loader
      @loader.detach()

    if @verifyProcessingInterval
      clearInterval(@verifyProcessingInterval)

    if data.files[0].type.match /gif|jpe?g|png/
      @clone = @container.find('[data-container="uploader"]:first').clone()
      @container.append(@clone)
      previewInstanceName = Manager.getInstanceName('UploaderPreview')
      preview = new UploaderPreview(@clone, data.files[0])
      @clone.data(previewInstanceName, preview)
      @previews[preview.id()] = preview
      data.context = preview.id()

      @container.closest('form').find('[type=submit]').attr("disabled", true)
      data.submit()

  getFormData: =>
    preview = @nextPreview()
    filePath = "uploads/#{preview.id()}/" + preview.file.name
    preview.filePath = filePath
    [
      { name: 'key', value: filePath },
      { name: 'acl', value: @container.find('input[name="acl"]').val()  },
      { name: 'Content-Type', value: preview.file.type },
      { name: 'AWSAccessKeyId', value: @container.find('input[name="AWSAccessKeyId"]').val() },
      { name: 'policy', value: @container.find('input[name="policy"]').val() },
      { name: 'signature', value: @container.find('input[name="signature"]').val() },
      { name: 'file', value: preview.file }
    ]

  progress: (e, data) =>
    @previews[data.context].progress(data)

  done: (e, data) =>
    @previews[data.context].done(data)

  fail: (e, data) =>
    @previews[data.context].fail(data)

  nextPreview: =>
    @currentIndex ||= 0
    key = Object.keys(@previews)[@currentIndex]
    @currentIndex++
    @previews[key]

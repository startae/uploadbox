class @ImageUploader
  constructor: (@container) ->
    @fileInput = @container.find('input[type="file"]')
    @idInput = @container.find('[data-item="id"]')
    @container.find('a.btn.fileupload-exists').bind('ajax:success', @delete)
    @fileInput.fileupload
      dataType: 'json'
      formData: {name: @fileInput.attr('name'), value: @fileInput.val()}
      add: @add
      progress: @progress
      done: @done

  add: (e, data) =>
    @loader = $('<div class="progress progress-striped"><div class="bar" style="width: 0%;"></div></div>').hide()
    @container.append(@loader.fadeIn())
    data.submit()

  progress: (e, data) =>
    progress = parseInt(data.loaded / data.total * 100, 10)
    @loader.find('.bar').css({width: progress + '%'})

  done: (e, data) =>
    image = data.result
    @loader.detach()
    @idInput.val(image.id)
    @container.find('a.btn.fileupload-exists').attr('href', image.url)
    @container.find('.fileupload-preview.thumbnail img').detach()
    img = $('<img/>')
    img.attr('src', image.versions.regular)
    img.attr('width', 50)
    img.attr('height', 50)
    @container.find('.fileupload-preview.thumbnail').append(img)
    @container.find('.fileupload').removeClass('fileupload-new').addClass('fileupload-exists')

  delete: =>
    @idInput.val('')
    @container.find('.fileupload-preview.thumbnail img').detach()
    @container.find('.fileupload').addClass('fileupload-new').removeClass('fileupload-exists')

$ ->
  $('[data-component="ImageUploader"]').each (i, el) ->
    $(el).data('image_uploader', new ImageUploader($(el)))


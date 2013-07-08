class @ImageUploader
  constructor: (@container) ->
    @preview = @container.find('[data-provides="fileupload"]')
    @fileInput = @container.find('input[type="file"]')
    @typeInput = @container.find('input[name="image[imageable_type]"]')
    @idInput = @container.find('[data-item="id"]')
    @container.find('a.btn.fileupload-exists').bind('ajax:success', @delete)
    @thumbContainer = @container.find('.fileupload-preview.thumbnail')
    @fileInput.fileupload
      dataType: 'json'
      formData: [{name: @fileInput.attr('name'), value: @fileInput.val()}, {name: @typeInput.attr('name'), value: @typeInput.val()}]
      add: @add
      progress: @progress
      done: @done

  add: (e, data) =>
    @loader = $('<div class="progress progress-striped active"><div class="bar" style="width: 0%;"></div></div>').hide()
    @preview.prepend(@loader.fadeIn())
    data.submit()

  progress: (e, data) =>
    progress = parseInt(data.loaded / data.total * 100, 10)
    @loader.find('.bar').css({width: progress + '%'})

  done: (e, data) =>
    image = data.result
    console.log image.versions
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

  delete: =>
    @idInput.val('')
    @container.find('.fileupload-preview.thumbnail img').detach()
    @container.find('.fileupload').addClass('fileupload-new').removeClass('fileupload-exists')

$ ->
  $('[data-component="ImageUploader"]').each (i, el) ->
    $(el).data('image_uploader', new ImageUploader($(el)))


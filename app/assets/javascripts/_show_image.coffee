class @ShowImage
  constructor: (@container) ->
    if @container.data('is-processing') == true
      loadImage @container.data('original'), @append, {
        maxWidth: @container.find('img').attr('width'),
        maxHeight: @container.find('img').attr('height'),
        minWidth: @container.find('img').attr('width'),
        minHeight: @container.find('img').attr('height'),
        canvas: true,
        crop: true,
        orientation: true
      }
  append: (img) =>
    @container.append(img)

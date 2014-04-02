class @Manager
  @getInstanceName: (className) ->
    className.charAt(0).toLowerCase() + className.slice(1)

  @init = (container) ->
    classNames = container.data('component').split(' ')

    for className in classNames
      if window[className]
        instanceName = Manager.getInstanceName(className)
        unless container.data(instanceName)
          instance = new (eval(className))(container)
          container.data(instanceName, instance)
      else
        console.warn "#{className} component not found"

$(document).ready ->
  $('[data-component]').each (i, el) -> Manager.init($(el))

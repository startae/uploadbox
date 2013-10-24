class @Manager
  @getInstanceName: (className) ->
    className.charAt(0).toLowerCase() + className.slice(1)

  @init = (container) ->
    classNames = container.data('component').split(' ')

    for className in classNames
      try
        instance = new (eval(className))(container)
        instanceName = Manager.getInstanceName(className)
        container.data(instanceName, instance)
      catch error
        try
          console.warn "#{className} component not found"

$(document).ready ->
  $('[data-component]').each (i, el) -> Manager.init($(el))
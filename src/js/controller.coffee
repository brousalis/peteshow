_     = require('lodash')
store = require('./storage')

Session = require('./models/session')

class PeteshowController
  view        : null
  session     : null
  sessions    : null
  lastSession : null

  init: (view) ->
    @view        = view
    @lastSession = store.get('last_session') || false
    @session     = store.get('active_session') || 'new'
    @sessions    = store.get('sessions')
    @view.render()
    @view.setSession(@session)

  fillOutForms: =>
    checkboxes = @fillCheckboxes()
    radios     = @fillRadioButtons()
    selects    = @fillSelectBoxes()
    inputs     = @fillInputs()

    if @session is 'last'
      for key, value of @lastSession
        $("[name*=#{key}]").val(value)

    @view.hideSaveSession()

    if @session isnt 'new' and @session isnt 'last'
      for key, value of store.getSessionStorage(@session)
        $("[name*=#{key}]").val(value)
      return

    @saveLastSession()

  fillOutFormsAndSubmit: =>
    @fillOutForms()
    $(Peteshow.options.form).submit()
    $('form').last().submit()

  fillInputs: ->
    for element, rule of Peteshow.options.rules
      value = if _.isFunction(rule) then rule() else rule
      $(element).each (i, el) =>
        return if $(el).is(Peteshow.options.ignore.toString())
        return if $(el).is(':checkbox')
        $(el)
          .filter(':visible')
          .filter('input:not(:checked)')
          .filterFields()
          .val(value)
        $(el).blur() if Peteshow.options.blur

  fillCheckboxes: ($inputs) ->
    for el in $('form input:checkbox')
      $(el)
        .prop('checked', true)
        .change()

  fillRadioButtons: ($inputs) ->
    return unless inputNames = @_uniqueInputNames($('form input:radio'))

    for name in inputNames
      $els   = $("form input:radio[name='#{name}']")
      random = Math.floor(Math.random() * $els.length)
      $el    = $els.eq(random)

      $el
        .prop('checked', true)
        .change()

  fillSelectBoxes: ($inputs) ->
    for el in $('form select')
      options = $.makeArray($(el).find('option'))
      values  = options.map (el) -> $(el).val()
      values  = _.difference(values, Peteshow.options.filters)

      random  = Math.floor(Math.random() * values.length)
      value   = values[random]

      $(el)
        .val(value)
        .change()

  _uniqueInputNames: ($inputs) ->
    return false if $inputs.length < 0
    _.uniq($inputs.map (i, $input) -> $input.name)

  deleteSession: (id) =>
    if id == 'last'
      store.deleteLastSession()
    else
      store.deleteSession(id)

    @session     = 'new'
    @sessions    = store.get('sessions')
    @lastSession = store.get('last_session')

    @view.update()
    @view.setSession(@session)

  saveLastSession: =>
    data = []

    $('form :input').each ->
      data[$(@).attr('name')] = $(@).val()

    @lastSession = store.lastSession(data)

    @view.update()
    @view.setSession(@session)

  saveSession: (data) =>
    data       = @lastSession unless data?

    details    = @view.getSaveDetails()
    data       = _.merge(data, details) if details?
    data.title = @sessionName(data)

    @session  = store.addSession(data)
    @sessions = store.get('sessions')

    @view.update()
    @view.setSession(@session)
    @view.hideSaveSession()

  setSession: (id) ->
    id = 'new' unless id?
    @session = id

  sessionName: (data) ->
    return false unless data
    return data.title if data.title
    return data[Peteshow.options.sessionName] if Peteshow.options.sessionName
    return "#{data.first_name} #{data.last_name}" if data.first_name and data.last_name
    return data.first_name if data.first_name
    return data.email if data.email
    data.id

  clearSessions: =>
    store.clearSessions()

    @session     = 'new'
    @sessions    = store.get('sessions')
    @lastSession = store.get('last_session')

    @view.update()
    @view.setSession(@session)

  printToConsole: (id) =>
    if id == 'last'
      stored = @lastSession
    else
      stored = store.getSessionStorage(id)

    console.group(@sessionName(stored))

    for key, value of stored
      console.log "#{key} : #{value}"

    console.groupEnd()

  $.fn.filterFields = ->
    @filter ->
      element = this
      ignored = false
      $.each Peteshow.options.ignore, (i, v) ->
        if $(element).is(v)
          ignored = true
        return
      !ignored
module.exports = new PeteshowController()

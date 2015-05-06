_ = require('lodash')
$ = require('jquery')
store = require('./storage')

class PeteshowController
  view: null
  session: null
  sessions: null
  lastSession: null

  init: (view) ->
    @view = view

    @session = store.get('active_session') || 'new'
    @sessions = store.get('sessions')
    @lastSession = store.get('last_session') || false

    @view.render()
    @view.setSession(@session)

  fillOutForms: =>
    checkboxes = @fillCheckboxes()
    radios = @fillRadioButtons()
    selects = @fillSelectBoxes()
    inputs = @fillInputs()

    if @session is 'last'
      for key, value of @lastSession
        $("[name*=#{key}]").val(value)
      return

    if @session isnt 'new' and @session isnt 'last'
      for key, value of store.getSession(@session)
        $("[name*=#{key}]").val(value)
      return

    @saveLastSession()

  fillOutFormsAndSubmit: =>
    @fillOutForms()
    $(Peteshow.options.form).submit()
    $('form').last().submit()
    return

  fillInputs: ->
    @_fillInputs(Peteshow.options.rules, true)
    @_fillInputs(Peteshow.options.force, false)
    Peteshow.options.special() if Peteshow.options.special?
    return

  _fillInputs: (inputs, ignoreHidden) ->
    for element, rule of inputs
      value = if _.isFunction(rule) then rule() else rule

      $(element).each (i, el) =>
        return if $(el).is(Peteshow.options.ignore.toString())
        return if $(el).is(':checkbox')

        $el = ignoreHidden and $(el).filter(':visible') or $(el)

        $el
          .filterFields()
          .val(value)

        $el.blur() if Peteshow.options.blur

  fillCheckboxes: ->
    for el in $('form input:checkbox')
      $(el)
        .filterFields()
        .prop('checked', true)
        .change()

  fillRadioButtons: ->
    return unless inputNames = @_uniqueInputNames($('form input:radio'))

    for name in inputNames
      $els   = $("form input:radio[name='#{name}']")
      random = Math.floor(Math.random() * $els.length)
      $el    = $els.eq(random)

      $el
        .filterFields()
        .prop('checked', true)
        .change()
    return

  fillSelectBoxes: ->
    for el in $('form select')
      options = $.makeArray($(el).find('option'))
      values  = options.map (el) -> $(el).val()
      values  = _.difference(values, Peteshow.options.filters)

      random  = Math.floor(Math.random() * values.length)
      value   = values[random]

      $(el)
        .filterFields()
        .val(value)
        .change()
    return

  _uniqueInputNames: ($inputs) ->
    return false if $inputs.length < 0
    return _.uniq($inputs.map (i, $input) -> $input.name)

  deleteSession: (id) =>
    store.deleteSession(id)

    @session     = 'new'
    @sessions    = store.get('sessions')
    @lastSession = store.get('last_session')

    @view.update()
    return id

  saveLastSession: =>
    data = []

    $('form :input').each ->
      data[$(@).attr('name')] = $(@).val()

    @lastSession = store.lastSession(data)

    @view.update()

    return @lastSession

  saveSession: (data) =>
    data       = @lastSession unless data?

    details    = @view.getSaveDetails()
    data       = _.merge(data, details) if details?
    data.title = @sessionName(data)

    session    = store.saveSession(data).id
    @sessions  = store.get('sessions')

    @setSession(session)

    @view.update()
    @view.hideSaveDialog()

  setSession: (id) ->
    id = 'new' unless id?
    @session = id

  sessionName: (data) ->
    data = store.getSession(@session) unless data?

    return false unless data
    return data.title if data.title
    return data[Peteshow.options.sessionName] if Peteshow.options.sessionName
    return "#{data.first_name} #{data.last_name}" if data.first_name and data.last_name
    return data.first_name if data.first_name
    return data.email if data.email

    data.id

  clearSessions: =>
    store.clearSessions()

    @session = 'new'
    @sessions = store.get('sessions')
    @lastSession = store.get('last_session')

    @view.update()

  printToConsole: (id) =>
    if id == 'last'
      stored = @lastSession
    else
      stored = store.getSession(id)

    console.group(@sessionName(stored))

    for key, value of stored
      console.log "#{key} : #{value}"

    console.groupEnd()

  # filters out fields that are listed in ignore
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

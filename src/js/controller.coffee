_     = require('lodash')
store = require('./storage')

Session = require('./models/session')

class PeteshowController
  view        : null
  session     : null
  lastSession : null

  init: (view) ->
    @view         = view
    @session      = store.get('active_session') || 'new'
    @last_session = store.get('last_session') || null

    @view.render()

  fillOutForms: =>
    if @session is 'last'
      for key, value of store.lastSession()
        $("[name=#{key}]").val(value)
      return

    inputs     = @fillInputs()
    radios     = @fillRadioButtons()
    checkboxes = @fillCheckboxes()
    selects    = @fillSelectBoxes()

    @saveLastSession()

  fillOutFormsAndSubmit: =>
    @fillOutForms()
    $(Peteshow.options.form).submit()

  fillInputs: ->
    for element, rule of Peteshow.options.rules
      value = if _.isFunction(rule) then rule() else rule
      $(element).each (i, el) =>
        return if $(el).is(Peteshow.options.ignore.toString())
        return if $(el).is(':checkbox')
        $(el).val(value)

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

  saveLastSession: ->
    data = []

    $('form :input').each ->
      data[$(@).attr('name')] = $(@).val()

    @lastSession = store.lastSession(data)

    @view.redraw()

  setSession: (id) ->
    @session = id

  getLastSession: ->
    return store.get('last_session') || false

  lastSessionName: ->
    session = @getLastSession
    return "#{session.first_name} #{session.last_name}" if session.first_name and session.last_name
    return session.first_name if session.first_name
    return session.email if session.email
    return session.id

module.exports = new PeteshowController()

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
    @lastSession = store.get('last_session')
    @session     = store.get('active_session') || 'new'
    @sessions    = store.get('sessions')

    @view.render()

  fillOutForms: =>
    if @session is 'last'
      for key, value of @lastSession
        $("[name=#{key}]").val(value)
      return

    inputs     = @fillInputs()
    radios     = @fillRadioButtons()
    checkboxes = @fillCheckboxes()
    selects    = @fillSelectBoxes()

    # if @session isnt 'new'
      #   merge new inputs into data
      #   updateSession(last or id)
    #   else

    @view.hideSaveSession()

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
    @view.update()

  saveSession: (session) ->
    true

  setSession: (id) ->
    id = 'new' if id == 'undefined'
    @session = id

module.exports = new PeteshowController()

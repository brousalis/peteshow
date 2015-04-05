_     = require('lodash')
store = require('./storage')

Session = require('./models/session')

class PeteshowController
  view    : null
  session : null

  init: (view) ->
    @view = view

    @resetSession()

  saveLastSession: ->
    data = []

    $(':input:not([name*=peteshow])').each ->
      data[$(@).attr('name')] = $(@).val()

    id = store.lastSession(data)

    @setSession(id)

  setSession: (id) -> @session = id

  resetSession: -> @view.setSession('new')

  fillOutForms: =>
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

      $(element).each (i, el) ->
        key = _.findKey(@session, (v, k) -> $(el).is(k))

        return $(el).val(@session[key]) if key != undefined

        return if $(el).is(':checkbox')
        return if $(el).is(Peteshow.options.ignore.toString())

        $(el).val(value)

  _uniqueInputNames: ($inputs) ->
    return false if $inputs.length < 0
    _.uniq($inputs.map (i, $input) -> $input.name)

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

module.exports = PeteshowController

_     = require('lodash')
store = require('./storage')

class PeteshowController
  view    : null
  session : null

  init: (view) ->
    @view = view
    @resetSession(Peteshow.options.resets)

  setSession: (id) ->
    @session = id

  saveSession: -> return

  resetSession: (resets) ->
    @view.setSession('new') if @hasReset(resets)

  hasReset: (resets) ->
    selectors = resets.join(',')
    $(selectors).length > 0

  getSessionStorage: (id) ->
    sessions = store.get('sessions') || {saved:null}
    _.find(sessions.saved, {id: id})

  fillOutForms: =>
    session = @getSessionStorage(@session) if @session != 'new' && @session != 'last'

    inputs     = @fillInputs()
    radios     = @fillRadioButtons()
    checkboxes = @fillCheckboxes()
    selects    = @fillSelectBoxes()

  fillOutFormsAndSubmit: =>
    @fillOutForms()
    $(Peteshow.options.form).submit()
    $('form[name*=registration]').submit()

  fillInputs: (session) ->
    saved    = Peteshow.options.saved
    elements = []

    for element, rule of Peteshow.options.rules
      value = if _.isFunction(rule) then rule() else rule

      $(element).each (i, el) ->
        key = _.findKey(saved, (v, k) -> $(el).is(k))

        return $(el).val(saved[key]) if key != undefined

        return if $(el).is(':checkbox')
        return if $(el).is(Peteshow.options.ignore.toString())

        $(el).val(value)

      elementHash = {}
      elementHash[element] = value
      elements.push(elementHash)

    return elements

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

_     = require('lodash')
store = require('./storage')

class PeteshowController
  view: null
  session: null

  init: (view) ->
    @view = view
    @resetSession(Peteshow.options.resets)

  setSession: (id) ->
    @session = id

  saveSession: -> return

  resetSession: (resets) ->
    @view.setSession("new") if @hasReset(resets)

  hasReset: (resets) ->
    selectors = resets.join(',')
    $(selectors).length > 0

  getSessionStorage: (id) ->
    sessions = store.get('sessions') || {saved:null}
    _.find(sessions.saved, {id: id})

  fillOutForms: =>
    @fillInputs()
    #radios     = @fillRadioButtons(session)
    #@fillCheckboxes()
    #@fillSelectBoxes()

  fillOutFormsAndSubmit: =>
    @fillOutForms()
    $(Peteshow.options.form).submit()
    $('form[name*=registration], .simple_form').submit()
    $('form').last().submit()

  fillInputs: (session) ->
    saved = Peteshow.options.saved

    elements = []

    for element, rule of Peteshow.options.rules
      value = if _.isFunction(rule) then rule() else rule

      # Well, we've made it this far. Let's go ahead and fill this form out
      $(element).each (i, el) ->
        # Restore saved fields values from the saved option
        key = _.findKey(saved, (v, k) -> $(el).is(k))
        if key != undefined
          return $(el).val(saved[key])

        return if $(el).is(':checkbox')
        ignored = $(el).is(Peteshow.options.ignore.toString())
        return if ignored
        $(el).val(value)

      elementHash = {}
      elementHash[element] = value
      elements.push(elementHash)
    return elements

  _uniqueInputNames: ($inputs) ->
    return false if $inputs.length < 0
    _.uniq($inputs.map (i, $input) -> $input.name)

  fillCheckboxes: ($inputs) ->
    for el in $('input:checkbox')
      # boolean = !!Peteshow.random.number(1)
      $(el)
        .prop('checked', true)
        .change()

  fillRadioButtons: ($inputs) ->
    return unless inputNames = @_uniqueInputNames($('input:radio'))

    for name in inputNames
      $els   = $("input:radio[name='#{name}']")
      random = Math.floor(Math.random() * $els.length)
      $el    = $els.eq(random)

      $el
        .prop('checked', true)
        .change()

  fillSelectBoxes: ($inputs) ->
    for el in $('select')
      options = $.makeArray($(el).find('option'))
      values  = options.map (el) -> $(el).val()
      values  = _.difference(values, Peteshow.options.filters)

      random = Math.floor(Math.random() * values.length)
      value  = values[random]

      $(el)
        .val(value)
        .change()

module.exports = PeteshowController

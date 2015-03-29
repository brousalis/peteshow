_     = require('lodash')
cs    = require('calmsoul')

class PeteshowController
  fillOutForms: =>
    cs.log('PeteshowController::fillOutForms')

    @fillInputs()
    @fillRadioButtons($('input:radio'))
    @fillCheckboxes($('input:checkbox'))
    @fillSelectBoxes($('select'))

  fillOutFormsAndSubmit: =>
    cs.log('PeteshowController::fillOutFormsAndSubmit')
    @fillOutForms()
    $(Peteshow.options.form).submit()
    $('form[name*=registration], .simple_form').submit()
    $('form').last().submit()

  fillInputs: ->
    cs.log('PeteshowController::fillInputs')
    saved = Peteshow.options.saved
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

  _uniqueInputNames: ($inputs) ->
    return false if $inputs.length < 0
    _.uniq($inputs.map (i, $input) -> $input.name)

  fillCheckboxes: ($inputs) ->
    cs.log('PeteshowController::fillCheckboxes')

    for el in $inputs
      # boolean = !!Peteshow.random.number(1)
      $(el)
        .prop('checked', true)
        .change()

  fillRadioButtons: ($inputs) ->
    cs.log('PeteshowController::fillRadioButtons')
    return unless inputNames = @_uniqueInputNames($inputs)

    for name in inputNames
      $els = $("input:radio[name='#{name}']")
      randomIndex = Math.floor(Math.random() * $els.length)
      $el = $els.eq(randomIndex)
      $el
        .prop('checked', true)
        .change()

  fillSelectBoxes: ($inputs) ->
    cs.log('PeteshowController::fillSelectBoxes')

    for el in $inputs
      selectOptions = $.makeArray($(el).find('option'))
      values = selectOptions.map (el) -> $(el).val()
      values = _.difference(values, Peteshow.options.filters)

      randomIndex = Math.floor(Math.random() * values.length)
      value = values[randomIndex]

      $(el)
        .val(value)
        .change()

module.exports = new PeteshowController()

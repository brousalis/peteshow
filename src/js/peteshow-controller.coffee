_ = require('lodash')

class PeteshowController
  fillOutForms: =>
    @fillInputs()
    @fillRadioButtons($('input:radio'))
    @fillCheckboxes($('input:checkbox'))
    @fillSelectBoxes($('select'))

  fillOutFormsAndSubmit: =>
    @fillOutForms()
    $(Peteshow.options.form).submit()
    $('form[name*=registration], .simple_form').submit()
    $('form').last().submit()

  fillInputs: ->
    saved = Peteshow.options.saved

    for element, rule of Peteshow.options.rules
      value = if _.isFunction(rule) then rule() else rule

      $(element).each (i, el) ->
        key = _.findKey(saved, (v, k) -> $(el).is(k))

        if key != undefined
          return $(el).val(saved[key])

        return if $(el).is(':checkbox')

        return if $(el).is(Peteshow.options.ignore.toString())

        $(el).val(value)

  _uniqueInputNames: ($inputs) ->
    return false if $inputs.length < 0
    _.uniq($inputs.map (i, $input) -> $input.name)

  fillCheckboxes: ($inputs) ->
    for el in $inputs
      # boolean = !!Peteshow.random.number(1)
      $(el)
        .prop('checked', true)
        .change()

  fillRadioButtons: ($inputs) ->
    return unless inputNames = @_uniqueInputNames($inputs)

    for name in inputNames
      $els   = $("input:radio[name='#{name}']")
      random = Math.floor(Math.random() * $els.length)
      $el    = $els.eq(random)

      $el
        .prop('checked', true)
        .change()

  fillSelectBoxes: ($inputs) ->
    for el in $inputs
      options = $.makeArray($(el).find('option'))
      values  = options.map (el) -> $(el).val()
      values  = _.difference(values, Peteshow.options.filters)

      random = Math.floor(Math.random() * values.length)
      value  = values[random]

      $(el)
        .val(value)
        .change()

module.exports = new PeteshowController()

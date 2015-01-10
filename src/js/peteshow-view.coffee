indexTemplate = require('../templates/index.hbs')

PeteshowView =
  render: ->
    console.log('PeteshowView::render')
    template = indexTemplate()
    $('body').append(template)

  show: ->
    console.log('PeteshowView::show')
    $('#peteshow').toggleClass('active')
    $('#peteshow-tools').toggle()

  hide: ->
    console.log('PeteshowView::hide')
    $('#peteshow').hide()

  destroy: -> console.log('PeteshowView::destroy')

PeteshowView.controller = require('./peteshow-controller')

events =
  '#fill-out-forms' : PeteshowView.controller.fillOutForms
  '#fill-out-forms-and-submit' : PeteshowView.controller.fillOutFormsAndSubmit
  '#peteshow-toggle': PeteshowView.show
  '#peteshow-hide': PeteshowView.hide

createEvents = (events) ->
  for key, value of events
    $("body").on 'click', key, (e) =>
      e.preventDefault()
      e.stopPropagation()
      events["##{e.target.id}"]()

# Constructor
console.log("PeteshowView::init")
createEvents(events)

module.exports = PeteshowView

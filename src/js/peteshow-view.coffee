Handlebars = require('handlebars')
indexTemplate = require('../templates/index.hbs')

module.exports =
  createEvents: (commands) ->
    $(command[0]).on('click', -> command[1]()) for command in commands

  render: ->
    console.log('PeteshowView::render')
    template = indexTemplate()
    $parent  = $('body')
    $parent.append(template)

  show: -> console.log('PeteshowView::show')
  hide: -> console.log('PeteshowView::hide')
  destroy: -> console.log('PeteshowView::destroy')

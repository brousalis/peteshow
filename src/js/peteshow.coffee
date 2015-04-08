window._ = _ = require('lodash')
window.$ = $ = require('jquery')

store    = require('./storage')
helpers  = require('./helpers')
rules    = require('./rules')

Peteshow =
  controller : null
  view       : null
  store      : store
  random     : helpers.random

  options    : {}
  defaults   :
    sessionName : null
    form        : ['form[name*=registration]']
    filters     : ['other', 'select']
    rules       : rules
    blur        : false
    ignore      : []
    force       : {}
    special     : null
    commands    : []

  init: (options = {}) ->
    @setOptions(options)

    @controller = require('./controller')
    @view       = require('./view')

    @controller.init(@view)

  setOptions: (options = {}) ->
    @options = _.merge(@defaults, options)

  hide: ->
    @view.hide()

  show: ->
    @view.show()

  open: (open) ->
    @view.open(open)

  destroy: ->
    @view.destroy()

  reset: (position) ->
    @view.reset(position)

  fillOutForms: ->
    @controller.fillOutForms()

exports = module.exports = window.Peteshow = Peteshow

window._ = _ = require('lodash')
global.$ = require('jquery')

store    = require('./storage')
helpers  = require('./helpers')

Peteshow =
  controller : null
  view       : null
  store      : store
  random     : helpers.random

  options    : {}
  defaults   :
    emailPrefix : 'test-'
    emailDomain : 'example.com'
    sessionName : null
    form        : ['form[name*=registration]']
    rules       : require('./rules')
    filters     : ['', 'other', 'select']
    blur        : false
    ignore      : []
    force       : {}
    special     : null

    # TODO:  implement
    commands    : ''
    events      : null

    # DEPRECATED
    saved       : {}
    reuse       : {}

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

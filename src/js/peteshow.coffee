window._ = _ = require('lodash')
store      = require('./storage')
helpers    = require('./helpers')

Peteshow =
  controller : null
  view       : null
  store      : store
  random     : helpers.random

  options  : {}
  defaults :
    emailPrefix : 'test-'
    emailDomain : 'example.com'
    form        : ['form[name*=registration]']
    rules       : require('./rules')
    filters     : ['', 'other', 'select']

    # TODO:  implement
    blur        : false
    cookies     : false
    force       : {}
    saved       : {}
    commands    : ''
    ignore      : []
    special     : null
    events      : null

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

window._ = _          = require('lodash')
store      = require('./peteshow-storage')
helpers    = require('./peteshow-helpers')
rules      = require('./peteshow-rules')
controller = require('./peteshow-controller')
view       = require('./peteshow-view')

Peteshow =
  view     : null
  store    : store
  random   : helpers.random
  options  : {}
  defaults :
    emailPrefix : 'test-'
    emailDomain : 'example.com'
    form        : ''
    blur        : false
    cookies     : false
    rules       : rules
    filters     : ['', 'other', 'select']
    ignore      : []
    force       : {}
    reuse       : {}
    saved       : {}
    commands    : ''
    special     : null
    events      : null

  init: (options = {}) ->
    @setOptions(options)

    @controller = controller
    @view       = view
    @view.render()

  setOptions: (options = {}) ->
    @options = _.merge(@defaults, options)

  show: (active) ->
    @view.show(active)

  destroy: ->
    @view.destroy()

  fillOutForms: ->
    @controller.fillOutForms()

exports = module.exports = window.Peteshow = Peteshow

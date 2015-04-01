window._ = _ = require('lodash')
store      = require('./storage')
helpers    = require('./helpers')
Controller = require('./controller')

Peteshow =
  controller : null
  view       : null
  store      : store
  random     : helpers.random

  options  : {}
  defaults :
    emailPrefix : 'test-'
    emailDomain : 'example.com'
    form        : ''
    blur        : false
    cookies     : false
    rules       : require('./rules')
    force       : {}

    # TODO:  refactor
    saved       : {}
    commands    : ''
    filters     : ['', 'other', 'select']
    ignore      : []
    special     : null
    events      : null
    resets      : []

  init: (options = {}) ->
    @setOptions(options)

    @controller = new Controller()
    @view       = require('./view')

    @view.render()
    @controller.init(@view)

  setOptions: (options = {}) ->
    @options = _.merge(@defaults, options)

  hide: ->
    @view.hide()

  show: ->
    @view.show()

  open: (active) ->
    @view.open(active)

  destroy: ->
    @view.destroy()

  fillOutForms: ->
    @controller.fillOutForms()

exports = module.exports = window.Peteshow = Peteshow

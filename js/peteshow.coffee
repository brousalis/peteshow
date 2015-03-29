window._ = _          = require('lodash')
store      = require('./peteshow-storage')
helpers    = require('./peteshow-helpers')
cs         = require('calmsoul')

cs.set
  "log"   : false
  "debug" : false
  "info"  : true

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

    rules       : require('./peteshow-rules')
    filters     : ['', 'other', 'select']
    ignore      : []
    force       : {}
    reuse       : {}
    saved       : {}
    commands    : ''
    special     : null
    events      : null

  init: (options = {}) ->
    cs.log('Peteshow::init', options)
    @setOptions(options)

    @controller = require('./peteshow-controller')
    @view = require('./peteshow-view')
    @view.render()

  setOptions: (options = {}) ->
    cs.log('Peteshow::setOptions')
    @options = _.merge(@defaults, options)

  show: (active) ->
    cs.log('Peteshow::show', active)
    @view.show(active)

  destroy: ->
    cs.log('Peteshow::destroy')
    @view.destroy()

  fillOutForms: ->
    cs.log('Peteshow::FillOutForms')
    @controller.fillOutForms()

exports = module.exports = window.Peteshow = Peteshow

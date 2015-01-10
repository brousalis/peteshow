_          = require('underscore')
store      = require('./peteshow-storage')
helpers    = require('./peteshow-helpers')

Peteshow =
  view       : null
  store      : store
  random     : helpers

  defaults   :
    emailPrefix : 'test-'
    emailDomain : 'example.com'
    form        : ''
    blur        : false
    cookies     : false

    rules       : []
    filter      : []
    ignore      : []
    force       : {}
    reuse       : {}
    commands    : ''
    special     : null
    events      : null

  init: (options = {}) ->
    @view = require('./peteshow-view')

    @setOptions(options)
    @view.render()

  setOptions: (options = {}) ->
    @defaults = _.defaults(options, @defaults)

exports = module.exports = window.Peteshow = Peteshow

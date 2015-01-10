_     = require('underscore')
rules = require('./peteshow-rules')
view  = require('./peteshow-view')

Peteshow = {
  store: require('./peteshow-storage')
  defaults:
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
    @defaults.rules = rules
    @setOptions(options)
    view.render()

  setOptions: (options = {}) ->
    @defaults = _.defaults(options, @defaults)
}

exports = module.exports = window.Peteshow = Peteshow

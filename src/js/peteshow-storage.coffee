store = require('store')

module.exports =
  get: (key) ->
    data = store.get('peteshow')
    return unless data
    return data[key] if key?
    data

  set: (key, data) ->
    _data = store.get('peteshow') || {}
    _data[key] = data
    store.set('peteshow', _data)

  clear: ->
    store.remove('peteshow')


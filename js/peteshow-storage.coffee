# LocalStorage should fallback to userData when not available
store = require('store')
cs    = require('calmsoul')

module.exports =
  get: (key) ->
    cs.log('PeteshowStorage::get')
    data = store.get('peteshow')
    return unless data
    return data[key] if key?
    data

  set: (key, data) ->
    cs.log('PeteshowStorage::set')
    _data = store.get('peteshow') || {}
    _data[key] = data
    store.set('peteshow', _data)

  clear: ->
    cs.log('PeteshowStorage::clear')
    store.remove('peteshow')


# LocalStorage should fallback to userData when not available
store = require('store')

module.exports =
  get: -> console.log('PeteshowStorage::get')
  set: (data) ->
    console.log('PeteshowStorage::set')
    data = JSON.stringify(data)
    store.set('peteshow', data)

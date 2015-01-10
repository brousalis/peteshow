# LocalStorage should fallback to cookies when not available
module.exports =
  get: -> console.log('PeteshowStorage::get')
  set: -> console.log('PeteshowStorage::set')

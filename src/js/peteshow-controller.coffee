module.exports =
  fillOutForms: -> console.log('PeteshowController::fillOutForms')
  fillOutFormsAndSubmit: -> console.log('PeteshowController::fillOutFormsAndSubmit')

  randomDate: -> console.log('PeteshowController::randomDate')
  randomEmail: -> console.log('PeteshowController::randomEmail')
  randomLetters: (n = 8) -> console.log('PeteshowController::randomLetters')
  randomNumber: (n = 8) -> console.log('PeteshowController::randomNumber')
  randomPhoneNumber: -> console.log('PeteshowController::randomPhoneNumber')
  randomPhoneNumberFormat: -> console.log('PeteshowController::randomPhoneNumberFormat')
  randomName:
    firstName: -> console.log('PeteshowController::randomName:firstName')
    lastName: -> console.log('PeteshowController::randomName:lastName')
    companyName: -> console.log('PeteshowController::randomName:companyName')
    catchPhrase: -> console.log('PeteshowController::randomName:catchPhrase')
  randomAddress:
    streetName: -> console.log('PeteshowController::randomAddress:streetName')
    secondary: -> console.log('PeteshowController::randomAddress:secondary')
    city: -> console.log('PeteshowController::randomAddress:city')
    zipCodeFormat: (n = 5) -> console.log('PeteshowController::randomAddress:zipCodeFormat')
    region: -> console.log('PeteshowController::randomAddress:region')
  randomCatchPhrase: -> console.log('PeteshowController::randomCatchPhrase')
  randomSentence: (n = 5) -> console.log('PeteshowController::randomSentence')

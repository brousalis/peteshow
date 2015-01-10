Faker = require('faker')
randomString = (length, chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') ->
  result = ''
  for i in [length..0]
    result += chars[Math.round(Math.random() * (chars.length - 1))]
  return result

module.exports =
  date: -> console.log('PeteshowHelpers::date')

  # General
  letters: (n = 8) ->
    console.log('PeteshowHelpers::letters')
    randomString(n)

  # Numbers
  number: (n = 8) ->
    console.log('PeteshowHelpers::number')
    Faker.random.number({min: 0, max: n})

  phoneNumber: (n = 5) ->
    console.log('PeteshowHelpers::phoneNumber')
    Faker.phone.phoneNumberFormat(1)

  # People
  #
  name: ->
    console.log('PeteshowHelpers::firstName')
    Faker.name.findName()

  firstName: ->
    console.log('PeteshowHelpers::firstName')
    Faker.name.firstName()

  lastName: ->
    console.log('PeteshowHelpers::lastName')
    Faker.name.lastName()

  companyName: ->
    console.log('PeteshowHelpers::companyName')
    Faker.company.companyName()

  email: -> console.log('PeteshowHelpers::email')

  # Address
  #
  street: ->
    console.log('PeteshowHelpers::street')
    Faker.address.streetAddress()

  secondary: ->
    console.log('PeteshowHelpers::secondary')
    Faker.address.secondaryAddress()

  city: ->
    console.log('PeteshowHelpers::city')
    Faker.address.city()

  state: ->
    console.log('PeteshowHelpers::state')
    Faker.address.state({full: true})

  stateAbbr: ->
    console.log('PeteshowHelpers::stateAbbr')
    Faker.address.stateAbbr()

  zipCode: (n = 5) ->
    console.log('PeteshowHelpers::zipCode')
    Faker.address.zipCode(n)

  # Lorem
  catchPhrase: (n = 4) ->
    console.log('PeteshowHelpers::catchPhrase')
    Faker.company.catchPhrase()

  sentences: (n = 5) ->
    console.log('PeteshowHelpers::sentences')
    Faker.lorem.sentences(n)

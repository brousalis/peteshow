Faker  = require('faker')
cs     = require('calmsoul')
moment = require('moment')

randomString = (length, chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') ->
  result = ''
  for i in [length..0]
    result += chars[Math.round(Math.random() * (chars.length - 1))]
  return result

module.exports =
  random:
    date: ->
      cs.log('PeteshowHelpers::date')
      moment(Faker.date.future(1)).format('YYYY-MM-DD')

    # General
    letters: (n = 8) ->
      cs.log('PeteshowHelpers::letters')
      randomString(n)

    # Numbers
    number: (n = 8) ->
      cs.log('PeteshowHelpers::number')
      Faker.random.number({min: 0, max: n})

    phoneNumber: (n = 5) ->
      cs.log('PeteshowHelpers::phoneNumber')
      Faker.phone.phoneNumberFormat(n)

    # People
    #
    name: ->
      cs.log('PeteshowHelpers::firstName')
      Faker.name.findName()

    firstName: ->
      cs.log('PeteshowHelpers::firstName')
      Faker.name.firstName()

    lastName: ->
      cs.log('PeteshowHelpers::lastName')
      Faker.name.lastName()

    companyName: ->
      cs.log('PeteshowHelpers::companyName')
      Faker.company.companyName()

    email: ->
      cs.log('PeteshowHelpers::email')
      Faker.internet.email()

    # Address
    #
    street: ->
      cs.log('PeteshowHelpers::street')
      Faker.address.streetAddress()

    secondary: ->
      cs.log('PeteshowHelpers::secondary')
      Faker.address.secondaryAddress()

    city: ->
      cs.log('PeteshowHelpers::city')
      Faker.address.city()

    county: ->
      cs.log('PeteshowHelpers::county')
      Faker.address.county()

    state: ->
      cs.log('PeteshowHelpers::state')
      Faker.address.state({full: true})

    stateAbbr: ->
      cs.log('PeteshowHelpers::stateAbbr')
      Faker.address.stateAbbr()

    zipCode: (n = 5) ->
      cs.log('PeteshowHelpers::zipCode')
      Faker.address.zipCode(n)

    # Lorem
    catchPhrase: (n = 4) ->
      cs.log('PeteshowHelpers::catchPhrase')
      Faker.company.catchPhrase()

    sentences: (n = 5) ->
      cs.log('PeteshowHelpers::sentences')
      Faker.lorem.sentences(n)

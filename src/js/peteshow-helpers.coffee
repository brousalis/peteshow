Faker  = require('faker')
moment = require('moment')

randomString = (length, chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') ->
  result = ''
  for i in [length..0]
    result += chars[Math.round(Math.random() * (chars.length - 1))]
  return result

module.exports =
  random:
    date: ->
      moment(Faker.date.future(1)).format('YYYY-MM-DD')

    # General
    letters: (n = 8) ->
      randomString(n)

    # Numbers
    number: (n = 8) ->
      Faker.random.number({min: 0, max: n})

    phoneNumber: (n = 5) ->
      Faker.phone.phoneNumberFormat(n)

    # People
    name: ->
      Faker.name.findName()

    firstName: ->
      Faker.name.firstName()

    lastName: ->
      Faker.name.lastName()

    companyName: ->
      Faker.company.companyName()

    email: ->
      Faker.internet.email()

    # Address
    street: ->
      Faker.address.streetAddress()

    secondary: ->
      Faker.address.secondaryAddress()

    city: ->
      Faker.address.city()

    county: ->
      Faker.address.county()

    state: ->
      Faker.address.state({full: true})

    stateAbbr: ->
      Faker.address.stateAbbr()

    zipCode: (n = 5) ->
      Faker.address.zipCode(n)

    # Lorem
    catchPhrase: (n = 4) ->
      Faker.company.catchPhrase()

    sentences: (n = 5) ->
      Faker.lorem.sentences(n)

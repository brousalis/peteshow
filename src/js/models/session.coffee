shortId = require('shortid')

class Session
  id: null
  email: null
  first_name: null
  last_name: null

  constructor: (data) ->
    @id = shortId.generate() unless data.id?

    for key, value of data
      @[key] = value

module.exports = Session


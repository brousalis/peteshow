shortId = require('shortid')

class Session
  id: null

  constructor: (data) ->
    @id = shortId.generate() unless data.id?

    for key, value of data
      @[key] = value

module.exports = Session


store = require('store')
_     = require('lodash')

Session = require('./models/session')

unless store.get('peteshow')
  store.set('peteshow', {})

module.exports =
  get: (key) ->
    data = store.get('peteshow') || {}
    return unless data
    return data[key] if key?
    data

  set: (key, data) ->
    storedData = @get()

    switch typeof data
      when 'array'
        storedData[key] = [] unless storedData[key]?
        _data = _.merge(storedData[key], data)

      when 'object'
        storedData[key] = {} unless storedData[key]?
        _data = _.merge(storedData[key], data)

      else
        _data = data

    storedData[key] = _data
    store.set('peteshow', storedData)

  sessions: ->
    @get('sessions') || []

  addSession: (data) ->
    session = new Session(data)
    data    = @sessions()

    data.sessions.push(session)
    @set('sessions', data)

    return session.id

  activeSession: (id) ->
    @set('active_session', id) if id?
    @get('active_session')

  lastSession: (data) ->
    session = new Session(data)

    @set('last_session', session) if data?
    @get('last_session')

    return session.id

  getAll: -> store.getAll().peteshow

  clear: -> store.remove('peteshow')

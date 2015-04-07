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
    return data

  set: (key, data) ->
    stored = @get()

    if data instanceof Array
      stored[key] = [] unless stored[key]?
      _data       = _.merge(stored[key], data)

    else if data instanceof Object
      stored[key] = {} unless stored[key]?
      _data       = _.merge(stored[key], data)

    else
      _data = data

    stored[key] = _data
    store.set('peteshow', stored)


  sessions: ->
    return @get('sessions') || []

  addSession: (data) ->
    session = new Session(data)
    data    = @get('sessions') || []

    data.push(session)
    @set('sessions', data)

    return session.id

  getSessionStorage: (id) ->
    sessions = @get('sessions')
    _.find(sessions, {id: id})

  deleteSession: (id) ->
    stored = @get()
    sessions = @get('sessions')

    stored['sessions'] = null
    _.remove(sessions, {id: id})

    data = _.merge(stored, {sessions: sessions})
    store.set('peteshow', data)

  activeSession: (id) ->
    @set('active_session', id) if id?
    @get('active_session')

  lastSession: (data) ->
    if data?
      session = new Session(data)
      @set('last_session', session)

    return @get('last_session')

  getAll: -> store.getAll().peteshow

  clearSessions: ->
    @set('sessions', [])
    @set('last_session', null)
    @set('active_session', null)

  clear: ->
    store.remove('peteshow')

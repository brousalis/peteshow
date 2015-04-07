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
    @get('sessions') || []

  getSessionStorage: (id) ->
    sessions = @sessions()
    _.find(sessions, {id: id})

  addSession: (data) ->
    session = new Session(data)
    data    = @sessions()

    data.push(session)
    @set('sessions', data)

    return session.id

  deleteSession: (id) ->
    stored   = @get()
    sessions = @sessions()

    stored['sessions'] = null
    _.remove(sessions, {id: id})
    data = _.merge(stored, {sessions: sessions})
    store.set('peteshow', data)

  activeSession: (id) ->
    @set('active_session', id) if id?
    @get('active_session')

  deleteLastSession: ->
    @set('last_session', null)

  lastSession: (data) ->
    if data? or data == {}
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

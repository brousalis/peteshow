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
    if key == 'sessions'
      return

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
    sessions = @get('sessions') || []

  addSession: (data) ->
    data = {sessions: @sessions()}
    data.sessions.push(new Session(data))
    @set('peteshow', data)

  activeSession: (id) ->
    if id?
      @set('active_session', id)
    @get('active_session')

  lastSession: ->
    @get('last_session')

  getAll: -> store.getAll().peteshow

  clear: ->
    store.remove('peteshow')


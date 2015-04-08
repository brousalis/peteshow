store = require('store')
cookie = require('mmm-cookies')
_     = require('lodash')

Session = require('./models/session')
cookies = true

unless store.get('peteshow')
  store.set('peteshow', {})

regex = new RegExp(/^([a-z]+\:\/{2})?([\w-]+\.[\w-]+\.\w+)$/)
url   = window.location.href

#if url.match(regex) or !store.enabled
cookies = true
unless cookie.get('peteshow')?
  console.log 'new'
  cookie.set('peteshow', JSON.stringify({}))

module.exports =
  get: (key) ->
    if cookies
      c = cookie.get('peteshow')
      data = JSON.parse(c) if c?
    else
      data = store.get('peteshow') || {}

    return unless data
    return data[key] if key?
    data

  set: (key, data) ->
    stored = @get()

    if data instanceof Array
      stored[key] = [] unless stored[key]?
      _data = _.merge(stored[key], data)

    else if data instanceof Object
      stored[key] = {} unless stored[key]?
      _data = _.merge(stored[key], data)

    else
      _data = data

    if key == 'sessions'
      stored['sessions'] = null
      console.log stored

    stored[key] = _data
    console.log stored

    if cookies
      cookie.set('peteshow', JSON.stringify(stored))
      console.log JSON.parse(cookie.get('peteshow'))
    else
      store.set('peteshow', stored)

  _getDomain: ->
    # http://rossscrivener.co.uk/blog/javascript-get-domain-exclude-subdomain
    i = 0
    d = document.domain
    p = d.split('.')
    s = '_gd' + (new Date).getTime()
    while i < p.length - 1 and document.cookie.indexOf(s + '=' + s) == -1
      d = p.slice(-1 - ++i).join('.')
      document.cookie = s + '=' + s + ';domain=' + d + ';'
    document.cookie = s + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;domain=' + d + ';'
    if d == 'localhost' then '' else d

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

  getAll: ->
    if cookie
      JSON.parse(cookie.get('peteshow'))
    else
      store.getAll().peteshow

  clearSessions: ->
    stored   = @get()

    stored['sessions'] = []
    stored['last_session'] = null
    stored['active_session'] = null

    store.set('peteshow', stored)

  clear: ->
    store.remove('peteshow')

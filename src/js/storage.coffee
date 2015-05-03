store = require('store')
_ = require('lodash')
Session = require('./models/session')

subdomain = new RegExp(/^([a-z]+\:\/{2})?([\w-]+\.[\w-]+\.\w+)$/)

# TODO: use cookies for subdomains
if (window.location.href).match(subdomain) or !store.enabled
  store = require('mmm-cookies')
  cookies = true

unless store.get('peteshow')
  store.set('peteshow', {})

module.exports =
  get: (key) ->
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

    stored[key] = _data

    store.set('peteshow', stored)

  sessions: ->
    @get('sessions') || []

  saveSession: (data) ->
    session = new Session(data)
    data = @sessions()

    data.push(session)
    @set('sessions', data)

    session

  activeSession: (id) ->
    @set('active_session', id) if id?
    @get('active_session')

  lastSession: (data) ->
    if data? or data == {}
      session = new Session(data)
      @set('last_session', session)

    @get('last_session')

  getSession: (id) ->
    sessions = @sessions()
    _.find(sessions, {id: id})

  deleteSession: (id) ->
    stored = @get()
    sessions = @sessions()

    stored['sessions'] = null
    _.remove(sessions, {id: id})

    data = _.merge(stored, {sessions: sessions})
    store.set('peteshow', data)

    id

  clearSessions: ->
    stored = @get()

    stored['sessions'] = []
    stored['last_session'] = null
    stored['active_session'] = null

    store.set('peteshow', stored)

  clear: ->
    store.remove('peteshow')

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

_     = require('lodash')
store = require('./storage')

Draggabilly = require('draggabilly')

indexTemplate       = require('../templates/index.hbs')
sessionsTemplate    = require('../templates/sessions.hbs')

class PeteshowView
  controller  : Peteshow.controller

  $peteshow    : '.peteshow'
  $tools       : '.peteshow-menu'
  $sessions    : '.peteshow-sessions'
  $saveSession : '.peteshow-save-session'

  constructor: ->
    @_position = store.get('position') || {x:0, y:0}
    @_open     = store.get('open')
    @_events   =
      'peteshow-hide'             : @hide
      'fill-out-forms'            : @controller.fillOutForms
      'fill-out-forms-and-submit' : @controller.fillOutFormsAndSubmit
      'save-last-session'         : @controller.saveSession
      'cancel-session'            : @hideSaveSession
      'toggle-save'               : @toggleSaveSession

  render: ->
    $('body').append(indexTemplate)

    @_positionWindow(store.get('position'))
    @_createEvents(@_events)

    @update()
    @open(@_open)

  update: ->
    lastSession = store.get('last_session')
    sessions    = store.get('sessions')

    $(@$sessions).html(
      sessionsTemplate
        lastSession     : lastSession
        lastSessionName : @controller.sessionName(lastSession)
        sessions        : sessions
    )

  _createEvents: (events) ->
    for key, value of events
      $('body').on 'click', "[data-action='#{key}']", (e) =>
        e.preventDefault()
        e.stopPropagation()
        events["#{e.currentTarget.dataset.action}"]()

    $(document).keydown @_handleKeydown

    @$drag = new Draggabilly(
      @$peteshow,
      handle      : '.peteshow-toggle',
      containment : 'html'
    )

    @$drag
      .on 'dragEnd', @_handleDragEnd
      .on 'staticClick', @open

    $('body').on 'change', '.peteshow-menu input:radio', (e) =>
      id = $(e.currentTarget).data('session')
      @controller.setSession(id)
      return

  _handleKeydown: (e) =>
    code = String.fromCharCode(e.keyCode)

    @open() if (e.keyCode == 192)

    action  = $("[data-command='#{code}']")
    visible = $(@$peteshow).is('.open')

    action.click() if (action.length > 0 and visible)

  _handleDragEnd: ->
    @_position = this.position
    store.set('position', @_position)

  _positionWindow: (position) ->
    unless position?
      position = @_position

    @_position = position
    $(@$peteshow).css(left: position.x, top: position.y)

  open: (open) =>
    if open == undefined || typeof open != 'boolean'
      open = !@_open

    $(@$tools).toggle(open)
    $(@$peteshow).toggleClass('open', open)
    @hideSaveSession()

    @_open = open
    store.set('open', @_open)

    return

  reset: (position) ->
    position = {x:0, y:0} unless position?

    @_positionWindow(position)
    @_position = position

    store.set('position', @_position)

    return position

  getSaveDetails: ->
    return {
      title: $(@$saveSession).find('[name="peteshow-title"]').val()
      notes: $(@$saveSession).find('[name="peteshow-notes"]').val()
    }

  setSession: (id) ->
    $(@$tools).find("[data-session=#{id}]").prop('checked', true).change()

  hideSaveSession: =>
    $(@$saveSession).hide()

  toggleSaveSession: =>
    $(@$saveSession).toggle()

  show: =>
    $(@$peteshow).show()

  hide: =>
    $(@$peteshow).hide()

  destroy: ->
    $(@$peteshow).remove()

module.exports = new PeteshowView()

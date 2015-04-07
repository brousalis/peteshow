_           = require('lodash')
store       = require('./storage')
Draggabilly = require('draggabilly')

indexTemplate    = require('../templates/index.hbs')
sessionsTemplate = require('../templates/sessions.hbs')

class PeteshowView
  controller   : Peteshow.controller

  $peteshow    : '.peteshow'
  $tools       : '.peteshow-menu'
  $handle      : '.peteshow-toggle'
  $sessions    : '.peteshow-sessions'
  $saveDialog  : '.peteshow-save-session'

  constructor: ->
    @_position = store.get('position') || {x:0, y:0}
    @_open     = store.get('open')
    @_events   =
      'save-session'              : @saveSession
      'cancel-session'            : @hideSaveSession
      'toggle-save'               : @toggleSaveSession
      'print-console'             : @printToConsole
      'delete-session'            : @deleteSession
    @_actions  =
      'peteshow-hide'             : @hide
      'fill-out-forms'            : @controller.fillOutForms
      'fill-out-forms-and-submit' : @controller.fillOutFormsAndSubmit
      'clear-store'               : @controller.clearSessions

  render: ->
    $('body').append(indexTemplate)

    @_positionWindow(store.get('position'))
    @_createEvents()

    @update()
    @open(@_open)

  update: ->
    lastSession = store.get('last_session')
    sessions    = store.get('sessions')
    template    =
      sessionsTemplate
        lastSession     : lastSession
        lastSessionName : @controller.sessionName(lastSession)
        sessions        : sessions

    $(@$sessions).html(template)

  _createEvents: () =>
    for key, value of @_events
      $('body').on 'click', "[data-action='#{key}']", (e) =>
        e.preventDefault()
        e.stopPropagation()
        @_events["#{e.currentTarget.dataset.action}"](e)

    for key, value of @_actions
      $("[data-action='#{key}']").on 'click', (e) =>
        e.preventDefault()
        e.stopPropagation()
        @_actions["#{e.currentTarget.dataset.action}"]()

    $('body').on 'change', "#{@$tools} input:radio", (e) =>
      id = $(e.currentTarget).data('session')
      @controller.setSession(id)

    $(document).keydown @_handleKeydown

    @$drag = new Draggabilly(@$peteshow, handle: @$handle, containment: 'html')
    @$drag
      .on 'dragEnd', @_handleDragEnd
      .on 'staticClick', @open

  _handleKeydown: (e) =>
    code = String.fromCharCode(e.keyCode)

    @open() if (e.keyCode == 192)

    action  = $("[data-key='#{code}']")
    visible = $(@$peteshow).is('.open')

    action.click() if (action.length > 0 and visible)

  _handleDragEnd: ->
    @_position = this.position
    store.set('position', @_position)

  _positionWindow: (position) ->
    position = @_position unless position?

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
      title: $(@$saveDialog).find('[name="peteshow-title"]').val()
      notes: $(@$saveDialog).find('[name="peteshow-notes"]').val()
    }

  saveSession: (e) =>
    @controller.saveSession()

  setSession: (id) ->
    $(@$tools)
      .find("[data-session=#{id}]")
      .prop('checked', true)
      .change()

  printToConsole: ->
    true

  deleteSession: (e) =>
    id = e.currentTarget.dataset.session
    @controller.deleteSession(id)

  hideSaveSession: =>
    $(@$saveDialog).hide()

  toggleSaveSession: =>
    $(@$saveDialog).toggle()

  show: =>
    $(@$peteshow).show()

  hide: =>
    $(@$peteshow).hide()

  destroy: ->
    $(@$peteshow).remove()

module.exports = new PeteshowView()

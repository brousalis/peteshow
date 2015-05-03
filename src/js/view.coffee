store = require('./storage')
Draggabilly = require('draggabilly')
_ = require('lodash')

indexTemplate = require('../templates/index.hbs')
sessionsTemplate = require('../templates/sessions.hbs')
commandTemplate = require('../templates/command.hbs')

class PeteshowView
  controller: Peteshow.controller

  $peteshow: '.peteshow'
  $tools: '.peteshow-menu'
  $handle: '.peteshow-toggle'
  $sessions: '.peteshow-sessions'
  $saveDialog: '.peteshow-save-session'

  constructor: ->
    @_position = store.get('position') || {x:0, y:0}
    @_open = store.get('open')
    @_commands = Peteshow.options.commands

    # @_events get redrawn when peteshow updates, have to handle
    # them differently than actions in @_createEvents

    @_events =
      'save-session': @saveSession
      'cancel-session': @hideSaveDialog
      'delete-session': @deleteSession
      'print-console': @printToConsole
      'toggle-save': @toggleSaveDialog

    @_actions =
      'peteshow-hide': @hide
      'fill-out-forms': @controller.fillOutForms
      'fill-out-and-submit': @controller.fillOutFormsAndSubmit
      'clear-sessions': @controller.clearSessions

    # merge custom command actions
    if @_commands
      list = {}
      for command in @_commands
        label = _.kebabCase(command['label'])
        _.assign(list, { "#{label}": command['action'] })
      _.assign(@_actions, list)

  # adds the view to the dom, creates events
  render: ->
    $('body').append(indexTemplate(commands: @_renderCommands))

    @_positionWindow(store.get('position'))
    @_createEvents()

    @update()
    @open(@_open)

  # redraws the view to update the save session dialog
  # and the last session
  update: ->
    lastSession = store.get('last_session')
    sessions = store.get('sessions')
    template =
      sessionsTemplate
        sessions: sessions
        lastSession: lastSession
        lastSessionName: @controller.sessionName(lastSession)

    $(@$sessions).html(template)

    @setSession(@controller.session)

  # binds events when peteshow is rendered
  _createEvents: () =>
    # handles events that get redrawn in update
    for k, v of @_events
      $('body').on 'click', "[data-action='#{k}']", (e) =>
        @_events["#{e.currentTarget.dataset.action}"](e)
        return false

    # handles events in the menu
    for k, v of @_actions
      $("[data-action='#{k}']").on 'click', (e) =>
        @_actions["#{e.currentTarget.dataset.action}"]()
        return false

    # radio buttons to choose session
    $('body').on 'change', "#{@$tools} input:radio", (e) =>
      id = $(e.currentTarget).data('session')
      @controller.setSession(id)

    # hotkeys
    $(document).keydown @_handleKeydown

    # dragging
    @$drag = new Draggabilly(
      @$peteshow,
      handle      : @$handle,
      containment : 'window'
    )
    @$drag
      .on 'dragEnd', @_handleDragEnd
      .on 'staticClick', @open

    # save last session when any form is submit
    $('form').on 'submit', @controller.saveLastSession

  # renders custom commands
  _renderCommands: =>
    html = ""

    for cmd in @_commands
      command = commandTemplate(
        label: cmd['label']
        action: _.kebabCase(cmd['label'])
        hotkey: cmd['hotkey'] if cmd['hotkey']
      )

      html = html + command

    return html

  # handles hotkeys
  _handleKeydown: (e) =>
    return true if $(@$saveDialog).is(':visible')

    code = String.fromCharCode(e.keyCode)

    @open() if (e.keyCode == 192)

    action  = $("[data-key='#{code}']")
    visible = $(@$peteshow).is('.open')

    action.click() if (action.length > 0 and visible)

  # save the position when dragging finishes
  _handleDragEnd: ->
    @_position = this.position
    store.set('position', @_position)

  # position the view
  _positionWindow: (position) ->
    position = @_position unless position?

    @_position = position
    $(@$peteshow).css(left: position.x, top: position.y)

  # opens and closes peteshow
  open: (open) =>
    if open == undefined || typeof open != 'boolean'
      open = !@_open

    $(@$tools).toggle(open)
    $(@$peteshow).toggleClass('open', open)
    @hideSaveDialog()

    @_open = open
    store.set('open', @_open)

    return

  # resets the position of the view
  reset: (position) ->
    position = {x:0, y:0} unless position?

    @_positionWindow(position)
    @_position = position

    store.set('position', @_position)

    return position

  # gets the values from the form on the save dialog
  getSaveDetails: ->
    return {
      title: $(@$saveDialog).find('[name="peteshow-title"]').val()
      notes: $(@$saveDialog).find('[name="peteshow-notes"]').val()
    }

  # sets the session in the view radio buttons
  setSession: (id) ->
    $(@$tools)
      .find("[data-session=#{id}]")
      .prop('checked', true)
      .change()

  saveSession: (e) =>
    @controller.saveSession()

  printToConsole: (e) =>
    id = e.currentTarget.dataset.session
    @controller.printToConsole(id)

  deleteSession: (e) =>
    id = e.currentTarget.dataset.session
    @controller.deleteSession(id)

  hideSaveDialog: =>
    $(@$saveDialog).hide()

  toggleSaveDialog: =>
    $(@$saveDialog).toggle()

  show: =>
    $(@$peteshow).show()

  hide: =>
    $(@$peteshow).hide()

  destroy: ->
    $(@$peteshow).remove()

module.exports = new PeteshowView()

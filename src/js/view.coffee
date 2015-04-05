_             = require('lodash')
template      = require('../templates/index.hbs')
store         = require('./storage')

Draggabilly   = require('draggabilly')

class PeteshowView
  controller  : Peteshow.controller

  $peteshow   : '#peteshow'
  $tools      : '#peteshow-menu'
  $sessions   : '#peteshow-sessions'

  constructor: ->
    @_position = store.get('position') || {x:0, y:0}
    @_open     = store.get('open')
    @_events   =
      '#fill-out-forms'            : @controller.fillOutForms
      '#fill-out-forms-and-submit' : @controller.fillOutFormsAndSubmit
      '#peteshow-hide'             : @hide

    $('body').append('<div id="peteshow" />')

  render: ->
    $(@$peteshow).html(
      template(
        lastSession : store.get('last_session')
        sessions    : store.get('sessions')
      )
    )
    @_positionWindow(store.get('position'))
    @_createEvents(@_events)
    @setSession('new')
    @open(@_open)

  _createEvents: (events) ->
    for key, value of events
      $(key).on 'click', (e) =>
        e.preventDefault()
        e.stopPropagation()
        events["##{e.target.id}"]()

    $(document).on 'keydown', @_handleKeydown

    @$drag = new Draggabilly(
      @$peteshow,
      handle      : '#peteshow-toggle',
      containment : 'html'
    )

    @$drag
      .on 'dragEnd', @_handleDragEnd
      .on 'staticClick', @open

    $(@$sessions).find('input:radio').on 'change', (e) =>
      id = $(e.currentTarget).data('session')
      @controller.setSession(id)

  _handleDragEnd: ->
    @_position = this.position
    store.set('position', @_position)

  _positionWindow: (position) ->
    if position == undefined
      position = @_position

    @_position = position
    $(@$peteshow).css(left: position.x, top: position.y)

  open: (open) =>
    if open == undefined || typeof open != 'boolean'
      open = !@_open

    $(@$tools).toggle(open)
    $(@$peteshow).toggleClass('open', open)

    @_open = open
    store.set('open', @_open)

    return

  reset: (position) ->
    if position == undefined
      position = {x:0, y:0}

    @_positionWindow(position)
    @_position = position

    store.set('position', @_position)

    return position

  setSession: (id) ->
    $(@$sessions).find("[data-session=#{id}]").prop('checked', true).change()

  _handleKeydown: (e) =>
    code = String.fromCharCode(e.keyCode)

    @open() if (e.keyCode == 192)

    action  = $("[data-command='#{code}']")
    visible = $(@$peteshow).is('.open')

    action.click() if (action.length > 0 and visible)

  show: =>
    $(@$peteshow).show()

  hide: =>
    $(@$peteshow).hide()

  destroy: ->
    $(@$peteshow).remove()

module.exports = new PeteshowView()

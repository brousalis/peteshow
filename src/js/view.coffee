_             = require('lodash')
indexTemplate = require('../templates/index.hbs')
store         = require('./storage')

class PeteshowView
  controller  : Peteshow.controller
  _events     : {}

  $peteshow   : '#peteshow'
  $dragHandle : '#peteshow-drag-handle'
  $tools      : '#peteshow-tools'
  $sessions   : '.peteshow-sessions'

  constructor: ->
    @_position = store.get('position') || {x:0, y:0}

    @_open = store.get('open')
    @_open = if typeof @_open != "boolean" then false else @_open

    @_events   =
      '#fill-out-forms'            : @controller.fillOutForms
      '#fill-out-forms-and-submit' : @controller.fillOutFormsAndSubmit
      '#peteshow-toggle'           : @open
      '#peteshow-hide'             : @hide

  render: ->
    template = indexTemplate()
    $('body').append(template)

    @_bindElements()
    @_positionWindow()
    @_createEvents(@_events)
    @open(@_open)

  _bindElements: ->
    @$peteshow   = $(@$peteshow)
    @$tools      = $(@$tools)
    @$dragHandle = $(@$dragHandle)
    @$sessions   = $(@$sessions)

  _createEvents: (events) ->
    for key, value of events
      $(key).on 'click', (e) =>
        e.preventDefault()
        e.stopPropagation()
        events["##{e.target.id}"]() unless @dragging

    __handleDragMove = _.throttle(@_handleDragMove, 10)
    __handleDragDown = _.debounce(@_handleDragDown, 100)
    __handleDragUp   = _.debounce(@_handleDragUp, 100)

    @$dragHandle.on 'mousedown', __handleDragDown
    $(document)
      .on 'mousemove', __handleDragMove
      .on 'mouseup', __handleDragUp

    $(document).keydown @_handleKeypress

    @$sessions.find('input:radio').on 'change', (e) =>
      id = $(e.currentTarget).data('session')
      @controller.setSession(id)

  _handleKeypress: (e) =>
    code = String.fromCharCode(e.keyCode)

    @open() if (e.keyCode == 192)

    action  = $("[data-command='#{code}']")
    visible = @$peteshow.is('.open')

    action.click() if (action.length > 0 && visible)

  _handleDragUp: =>
    @dragging = false
    document.onmousedown= -> return false
    store.set('position', @_position)

  _handleDragDown: =>
    @dragging = true
    document.onmousedown= -> return true

  _handleDragMove: (e) =>
    if @dragging
      position = {}
      position.x = e.pageX - @$peteshow.width()
      position.y = e.pageY
      @_positionWindow(position)

  _positionWindow: (position) ->
    $el = @$peteshow
    if position
      position.x = 0 if position.x < 0
      position.y = 0 if position.y < 0

      position.x = window.innerWidth - $el.width() if position.x > window.innerWidth - $el.width()
      position.y = window.innerHeilght if position.y > window.innerHeight

      elBottom        = $el.height() + $el.offset().top
      windowBottom    = $(window).height()
      mouseBottomDiff = $el.offset().top - position.y + windowBottom - $el.height()

      position.y = windowBottom - $el.height() if position.y >= mouseBottomDiff
      @_position = position

    position ?= @_position
    $el.css(left: position.x, top: position.y)

  open: (open) =>
    if open == undefined
      open = !@_open

    @$peteshow.toggleClass('open', open)
    @$tools.toggle(open)

    store.set('open', open)
    @_open = open

  setSession: (id) ->
    @$sessions.find("[data-session=#{id}]").prop('checked', true).change()

  show: =>
    @$peteshow.show()

  hide: =>
    @$peteshow.hide()

  destroy: ->
    @$peteshow.remove()

module.exports = new PeteshowView()

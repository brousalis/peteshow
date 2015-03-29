_             = require('lodash')
indexTemplate = require('../templates/index.hbs')
store         = require('./peteshow-storage')
hand = require('hand')

class PeteshowView
  controller  : Peteshow.controller
  _events     : {}

  $peteshow   : '#peteshow'
  $dragHandle : '#peteshow-drag-handle'
  $tools      : '#peteshow-tools'

  constructor: ->
    @_position = store.get('position') || {x:0, y:0}
    @_active   = store.get('active') || false
    @_events   =
      '#fill-out-forms'            : @controller.fillOutForms
      '#fill-out-forms-and-submit' : @controller.fillOutFormsAndSubmit
      '#peteshow-toggle'           : @show
      '#peteshow-hide'             : @hide

  _bindElements: ->
    @$peteshow   = $(@$peteshow)
    @$tools      = $(@$tools)
    @$dragHandle = $(@$dragHandle)

  _createEvents: (events) ->
    for key, value of events
      $(key).on 'click', (e) =>
        e.preventDefault()
        e.stopPropagation()
        events["##{e.target.id}"]() unless @dragging

    el = document.getElementById('peteshow')
    hl = document.getElementById('peteshow-drag-handle')

    el.addEventListener 'mousedown', (e) ->
      hand.grab(el, e.offsetX, e.offsetY)

    el.addEventListener 'mouseup', (e) ->
      hand.drop(el)

    $(document).keydown @_handleKeypress

  _handleKeypress: (e) =>
    code = String.fromCharCode(e.keyCode)

    @show() if (e.keyCode == 192)

    action  = $("[data-command='#{code}']")
    visible = @$peteshow.is('.active')

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
      position.x = e.pageX
      position.y = e.pageY
      @_positionWindow(position)

  _positionWindow: (position) ->
    $el = @$peteshow
    if position
      position.x = 0 if position.x < 0
      position.y = 0 if position.y < 0

      elBottom = $el.height() + $el.offset().top
      windowBottom = $(window).height()
      mouseBottomDiff = $el.offset().top - position.y + windowBottom - $el.height()

      position.y = windowBottom - $el.height() if position.y >= mouseBottomDiff
      @_position = position

    position ?= @_position
    $el.css(left: position.x, top: position.y)

  render: ->
    template = indexTemplate()
    $('body').append(template)

    @_bindElements()
    @_positionWindow()
    @_createEvents(@_events)
    @show(@_active)

  show: (active) =>
    if active == undefined
      active = !@_active

    @$peteshow.toggleClass('active', active)
    @$tools.toggle(active)

    store.set('active', active)
    @_active = active

  hide: =>
    $('#peteshow').show(false)

  destroy: ->
    $('#peteshow').remove()

module.exports = new PeteshowView()

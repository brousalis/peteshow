_             = require('lodash')
indexTemplate = require('../templates/index.hbs')
store         = require('./peteshow-storage')
cs            = require('calmsoul')

class PeteshowView
  controller: Peteshow.controller
  _events: {}

  $peteshow: '#peteshow'
  $dragHandle: '#peteshow-drag-handle'
  $tools: '#peteshow-tools'

  constructor: ->
    cs.log("PeteshowView::init")
    @_position = store.get('position') || {x:0, y:0}
    @_active = store.get('active') || false
    @_events =
      '#fill-out-forms' : @controller.fillOutForms
      '#fill-out-forms-and-submit' : @controller.fillOutFormsAndSubmit
      '#peteshow-toggle': @show
      '#peteshow-hide': @hide

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

    __handleDragMove = _.throttle(@_handleDragMove, 10)
    __handleDragDown = _.debounce(@_handleDragDown, 100)
    __handleDragUp = _.debounce(@_handleDragUp, 100)

    @$dragHandle.on 'mousedown', __handleDragDown
    $(document)
      .on 'mousemove', __handleDragMove
      .on 'mouseup', __handleDragUp

    $(document).keydown @_handleKeypress

  _handleKeypress: (e) =>
    # key  = if (typeof e.which == 'number') then e.which else e.keyCode
    code = String.fromCharCode(e.keyCode)

    # # modifier keys
    # code = 'ctrl_'+code if (e.ctrlKey)
    # if (e.altKey || (e.originalEvent && e.originalEvent.metaKey))
    #   code = 'alt_'+code
    # if (e.shiftKey)
    #   code = 'shift_'+code
    # return if ($.inArray(e.keyCode, [9,16,17,18, 91, 93, 224]) != -1)
    # return if (e.metaKey)

    cs.log(e.keyCode)
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

      cs.log position
      position.y = windowBottom - $el.height() if position.y >= mouseBottomDiff
      cs.log position
      @_position = position

    position ?= @_position
    $el.css(left: position.x, top: position.y)

  render: ->
    cs.log('PeteshowView::render')

    template = indexTemplate()
    $('body').append(template)

    @_bindElements()
    @_positionWindow()
    @_createEvents(@_events)
    @show(@_active)

  show: (active) =>
    if active == undefined
      active = !@_active

    cs.debug('PeteshowView::show', active)

    @$peteshow.toggleClass('active', active)
    @$tools.toggle(active)

    store.set('active', active)
    @_active = active

  hide: =>
    cs.log('PeteshowView::hide')
    $('#peteshow').show(false)

  destroy: ->
    cs.log('PeteshowView::destroy')
    $('#peteshow').remove()

module.exports = new PeteshowView()

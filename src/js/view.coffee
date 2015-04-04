_             = require('lodash')
template      = require('../templates/index.hbs')
store         = require('./storage')

Draggabilly   = require('draggabilly')

class PeteshowView
  controller  : Peteshow.controller

  $peteshow   : '#peteshow'
  $tools      : '#peteshow-tools'
  $sessions   : '#peteshow-sessions'

  constructor: ->
    @_position = store.get('position') || {x:0, y:0}
    console.log @_position

    @_open = store.get('open')
    @_open = if typeof @_open != "boolean" then false else @_open

    @_events   =
      '#fill-out-forms'            : @controller.fillOutForms
      '#fill-out-forms-and-submit' : @controller.fillOutFormsAndSubmit
      '#peteshow-hide'             : @hide

  render: ->
    $('body').append(template)

    @_bindElements()
    @_positionWindow()
    @_createEvents(@_events)
    @open(@_open)

  _bindElements: ->
    @$drag     = new Draggabilly(@$peteshow)
    @$peteshow = $(@$peteshow)
    @$tools    = $(@$tools)
    @$sessions = $(@$sessions)

  _createEvents: (events) ->
    for key, value of events
      $(key).on 'click', (e) =>
        e.preventDefault()
        e.stopPropagation()
        events["##{e.target.id}"]()

    $(document).on 'keydown', @_handleKeydown

    @$drag.on 'dragEnd', @_handleDragEnd
    @$drag.on 'staticClick', @open

    @$sessions.find('input:radio').on 'change', (e) =>
      id = $(e.currentTarget).data('session')
      @controller.setSession(id)

  _handleKeydown: (e) =>
    code = String.fromCharCode(e.keyCode)

    @open() if (e.keyCode == 192)

    action  = $("[data-command='#{code}']")
    visible = @$peteshow.is('.open')

    action.click() if (action.length > 0 && visible)

  _handleDragEnd: ->
    @_position = this.position
    console.log @_position
    store.set('position', @_position)

  _positionWindow: ->
    $el = @$peteshow
    $el.css(left: @_position.x, top: @_position.y)

  open: (open) =>
    if open == undefined
      open = !@_open

    @$tools.toggle()
    @$peteshow.toggleClass('open')

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

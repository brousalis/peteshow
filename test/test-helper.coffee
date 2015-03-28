process.env.NODE_ENV = 'test'

{ isRegExp }   = require("util")
assert         = require("assert")
global.Server  = require('./test-server')
global.Browser = require('zombie')

server         = new Server({port: 3017})
global.browser = browser = new Browser({ site: 'http://localhost:3017' })

global.REGEX   =
  NUMBER     : /^[0-9]*$/
  TEXT       : /^[a-zA-Z0-9.',\/_\s\r\n-]+$/
  EMAIL      : /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/i
  DATE       : /^(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])$/
  PHONE      : /\(\d{3}\)\s{0,1}\d{3}-\d{4}/
  STATE_ABBR : /^[A-Z]{2}$/i
  ZIP_CODE   : /^[0-9]{1,5}[-]?[0-9]{4}$/i

# This is actually a Zombie.js method that we should figure out how to get
# access to
assertMatch = (actual, expected, message) ->
  if isRegExp(expected)
    assert expected.test(actual), message || "Expected '#{actual}' to match #{expected}"
  else if typeof(expected) == "function"
    assert expected(actual), message
  else
    assert.deepEqual actual, expected, message

# Zombie.js' assert.input() tests against querySelectorAll...
# causing failures against the desired behavior
Browser.Assert.prototype.inputFirst = (selector, expected, message) ->
  expected = null if arguments.length == 1
  element = @browser.query(selector)
  assert element, "Expected selector '#{selector}' to return an element"

  value = element.value.replace(/(\r\n|\n|\r)/gm,"")
  assertMatch value, expected, message

# Key event method
Browser.prototype.key = (keyAction, keyCode, callback)->
  assert @window, "No window open"
  event = @window.document.createEvent("KeyboardEvent")
  event.initEvent("key#{keyAction}", true, true)
  event.which = keyCode
  event.keyCode = keyCode
  @window.document.dispatchEvent(event)
  # Only run wait if intended to
  unless callback == false
    return @wait(callback)

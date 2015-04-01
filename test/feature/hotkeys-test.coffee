describe 'Hotkeys', ->

  beforeEach (done) ->
    browser.visit('/')
      .then ->
        initPeteshow = "Peteshow.init()"
        browser.evaluate(initPeteshow)
        done()

  it 'should show peteshow when backtick is pressed', (done) ->
    browser.assert.hasNoClass('#peteshow', 'open')
    browser.key('down', 192)
    browser.assert.hasClass('#peteshow', 'open')
    done()

  it 'should fill out forms when F is pressed', (done) ->
    browser.evaluate("Peteshow.show(true)")
    browser.key('down', 70)
    browser.assert.inputFirst("input", /^.+$/)
    done()


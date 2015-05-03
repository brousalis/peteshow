describe 'Storage', ->

  beforeEach (done) ->
    browser.visit('/')
      .then ->
        initPeteshow = "Peteshow.init({ });"
        browser.evaluate(initPeteshow)
        done()

  checkStorage = (value) ->
    it 'restores the open state from last session', (done) ->
      browser.assert.evaluate("Peteshow.store.get('open')", value)
      done()

  it 'changes the open state to true', (done) ->
    browser.evaluate("Peteshow.open(true)")
    browser.assert.hasClass('.peteshow', 'peteshow', 'open')
    done()
  checkStorage(true)

  it 'changes the open state to true', (done) ->
    browser.evaluate("Peteshow.open(false)")
    browser.assert.hasNoClass('.peteshow', 'open')
    done()
  checkStorage(false)

  it "creates last session after submitting a form", (done) ->
    browser.pressButton "submit", (err) ->
      browser.assert.evaluate("$('#peteshow .peteshow-sessions [data-session=last]').prop('checked')", true)
    done()

  it "creates last session after filling out forms", (done) ->
    browser.evaluate("Peteshow.fillOutForms()")
    browser.assert.evaluate("Peteshow.store.get('last_session')", {})
    done()

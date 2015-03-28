describe 'Storage', ->

  beforeEach (done) ->
    browser.visit('/')
      .then ->
        initPeteshow = "Peteshow.init({ });"
        browser.evaluate(initPeteshow)
        done()

  checkStorage = (value) ->
    it 'restores the active state from last session', (done) ->
      browser.assert.evaluate("Peteshow.store.get('active')", value)
      done()

  it 'changes the active state to true', (done) ->
    browser.evaluate("Peteshow.show(true)")
    browser.assert.hasClass('#peteshow', 'active')
    done()
  checkStorage(true)

  it 'changes the active state to true', (done) ->
    browser.evaluate("Peteshow.show(false)")
    browser.assert.hasNoClass('#peteshow', 'active')
    done()
  checkStorage(false)

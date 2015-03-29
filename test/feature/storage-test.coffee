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
    browser.evaluate("Peteshow.show(true)")
    browser.assert.hasClass('#peteshow', 'open')
    done()
  checkStorage(true)

  it 'changes the open state to true', (done) ->
    browser.evaluate("Peteshow.show(false)")
    browser.assert.hasNoClass('#peteshow', 'open')
    done()

  context "Last Session", ->
    it "switches you to new session when visiting the first form page", (done) ->
      browser.assert.evaluate("$('#peteshow .peteshow-sessions [data-session=new]').prop('checked')", true)
      done()

    it "creates last session after submitting a form", (done) ->
      browser.pressButton "submit", (err) ->
        browser.assert.evaluate("$('#peteshow .peteshow-sessions [data-session=last]').prop('checked')", true)
        # browser.assert.success()
        done()
      # .then ->
      #   done()

    it "restores last session", (done) ->
      expect(false).to.be(true)
      done()
  checkStorage(false)

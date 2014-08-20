module('helpers');

test('should be defined on window', function() {
  equal(true, $.isPlainObject(Peteshow), 'window.Peteshow exists');
});

// replace this nonsense with functional tests
test('should exist in peteshow', function() {
  equal(true, $.isFunction(Peteshow.randomChars), 'randomChars is a function');
  equal(true, $.isFunction(Peteshow.randomLetters), 'randomLetters is a function');
  equal(true, $.isFunction(Peteshow.randomNumberRange), 'randomNumberRange is a function');
  equal(true, $.isFunction(Peteshow.randomNumber), 'randomNumber is a function');
  equal(true, $.isFunction(Peteshow.randomDate), 'randomDate is a function');
  equal(true, $.isFunction(Peteshow.randomEmail), 'randomEmail is a function');
  equal(true, $.isFunction(Peteshow.formatDate), 'formatDate is a function');

  equal(true, $.isFunction(Peteshow.init), 'init helper is a function');
  equal(true, $.isFunction(Peteshow.hide), 'hide helper is a function');
  equal(true, $.isFunction(Peteshow.toggle), 'toggle helper is a function');
  equal(true, $.isFunction(Peteshow.show), 'show helper is a function');
  equal(true, $.isFunction(Peteshow.destroy), 'destroy helper is a function');
  equal(true, $.isFunction(Peteshow.fillOutForms), 'fillOutForms helper is a function');
  equal(true, $.isFunction(Peteshow.submitForm), 'submitForm helper is a function');
  equal(true, $.isFunction(Peteshow.clearLocalStorage), 'clearLocalStorage helper is a function');
  equal(true, $.isFunction(Peteshow.clearCookies), 'clearCookies helper is a function');
  equal(true, $.isFunction(Peteshow.clearSaved), 'clearSaved helper is a function');
  equal(true, $.isFunction(Peteshow.getSavedFields), 'getSavedFields helper is a function');
  equal(true, $.isFunction(Peteshow.setSavedFields), 'setSavedFields helper is a function');
});

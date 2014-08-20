module('reusing values from localstorage', {
  setup: function() {
    Peteshow.init({
      reuse : {
        'input[name*=first_name]' : '/tests',
      }
    });
  },
  teardown: function() {
    Peteshow.destroy();
    Peteshow.clearLocalStorage();
  }
});

test('fields are saved into localstorage', function() {
  Peteshow.fillOutForms(); // store initial values

  var field = 'input[name*=first_name]',
      input = $(field).val();

  // field was saved
  ok(localStorage.getItem('peteshow') != null, 'localstorge isnt null')

  var saved = Peteshow.getSavedFields();

  // saved values equal the initial values
  equal(saved[field], input, 'saved value equals initial input');

  // clear form and re-fill
  $(field).val('');
  Peteshow.fillOutForms();

  // value is reused on field
  equal($(field).val(), saved[field], 'reused value equals initial input')
});

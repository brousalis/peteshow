module('reusing values from cookies', {
  setup: function() {
    Peteshow.init({
      cookies : true,
      reuse   : {
        'input[name*=first_name]' : '/tests',
      }
    });
  },
  teardown: function() {
    Peteshow.destroy();
    Peteshow.storage.clear();
  }
});

test('fields are saved into cookies', function() {
  Peteshow.fillOutForms(); // store initial values

  var field = 'input[name*=first_name]',
      input = $(field).val();

  // field was saved
  ok($.cookie('peteshow') != null, 'cookie isnt null')

  var saved = Peteshow.storage.get();

  // saved values equal the initial values
  equal(saved[field], input, 'saved value equals initial input');

  // clear form and re-fill
  $(field).val('');
  Peteshow.fillOutForms();

  // value is reused on field
  equal($(field).val(), saved[field], 'reused value equals initial input')
});

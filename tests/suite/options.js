module('options', {
  setup: function() {
    Peteshow.init({
      form          : '#random',
      emailPrefix   : 'pete-',
      emailDomain   : 'peteshow.com',
      blur          : 'true'
    });
  },
  teardown: function() {
    Peteshow.destroy();
  }
});

test('should set email options', function() {
  Peteshow.fillOutForms();

  var email = $('input[name*=email]').val().split('@')

  equal(true, /pete-/.test(email[0]), 'emailPrefix can be set')
  equal('peteshow.com', email[1], 'emailDomain can be set')
});

test('should blur after filling out if true', function() {
  expect(1);

  $('input[name*=first_name]').on('blur', function() {
    ok(true, 'blur functionality works');
  });

  Peteshow.fillOutForms();
});

test('should fill out custom form name', function() {
  expect(1);

  $('form[name*=random]').on('submit', function() {
    ok(true, 'submit form works');
    return false
  });

  Peteshow.submitForm();
});

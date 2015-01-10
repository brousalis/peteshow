module('core plugin', {
  setup: function() {
    NUMBER_REGEX        = /^[0-9]*$/
    TEXT_REGEX          = /^[a-zA-Z0-9.',\/_ -]+$/
    EMAIL_REGEX         = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/i
    DATE_REGEX          = /^(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])$/
    PHONE_NUMBER_REGEX  = /\(\d{3}\)\d{3}-\d{4}/

    Peteshow.init({
      rules  : {
        'input[name*=zip]'              : '60611',
        'input[name*=middle_name]'      : Faker.Name.firstName(),
        'input[name*=custom_name]'      : function() { return 'Custom' },
        'input[name*=boolean_checkbox]' : true,
      },
      ignore : ['input[name=phone]', '#qunit-modulefilter'],
    });
  },
  teardown: function() {
    Peteshow.destroy();
  }
});

test('should be defined on window', function() {
  equal(true, $.isPlainObject(Peteshow), 'window.Peteshow exists');
});

test('should have been added to the dom', function() {
  equal(1, $('#peteshow').length, 'peteshow exists')
});

test('should have valid values from defaults after filling out forms', function() {
  Peteshow.fillOutForms();

  var fields = {
    'input[type=password]'                        : 'password',
    'input[type=text]'                            : TEXT_REGEX,
    'input[type=email], input[name*=email]'       : EMAIL_REGEX,
    'input[name*=number], input[type=number]'     : NUMBER_REGEX,
    'input[type=date]'                            : DATE_REGEX,
    'input[name*=first_name]'                     : TEXT_REGEX,
    'input[name*=last_name]'                      : TEXT_REGEX,
    'input[name*=company]'                        : TEXT_REGEX,
    'input[name*=street], input[name*=line1]'     : TEXT_REGEX,
    'input[name*=line2], input[name*=suite]'      : TEXT_REGEX,
    'input[name*=city]'                           : TEXT_REGEX,
    'input[name*=state]'                          : TEXT_REGEX,
    'input[name*=job_title]'                      : TEXT_REGEX,
    'input[name*=intent]'                         : TEXT_REGEX,
    'input[name*=income], input[name*=amount]'    : NUMBER_REGEX,
    'input[name*=branch], input[name*=routing]'   : '400001',
    'input[name*=card_type_cd]'                   : '001',
    'input[name*=card_number]'                    : '4111111111111111',
    'input[name*=cvv]'                            : '123',
  }

  $.each(fields, function(k,v) {
    if(v.hasOwnProperty('source'))
      equal(true, v.test($(k).val()), 'testing ' + k + ' regex');
    else
      equal(v, $(k).val(), 'testing ' + k + ' string');
  });
});

test('should ignore fields', function() {
  Peteshow.fillOutForms();
  equal(true, $('input[name=phone]').val() == '');
});

test('should have valid values from plugin after filling out forms', function() {
  Peteshow.fillOutForms();

  equal('60611', $('input[name*=zip]').val(), 'rule loaded from plugin, string');
  equal('Custom', $('input[name*=custom_name]').val(), 'rule loaded from plugin, function');
});

test('should not change value of checkbox but attribute checked', function() {
  Peteshow.fillOutForms();

  equal('1', $('input[name=boolean_checkbox]').val(), 'checkbox value should be inmutables');
  equal(true, $('input[name=boolean_checkbox]').prop('checked'), 'should changed the attributed to checked');

});

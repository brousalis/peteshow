module('keybindings', {
  setup: function() {
    Peteshow.init();
    Peteshow.show();
  },
  teardown: function() {
    Peteshow.destroy();
  }
});

test('should show when backtick is pressed', function() {
  ok($('#peteshow').hasClass('active'));
});

test('should fill out forms when F is pressed', function() {
  var event = $.Event('keydown');

  event.keyCode = 70;
  $(document).trigger(event);

  ok($('form input').first().val() != '')
});

test('should clear saved fields when R is pressed', function() {
  var event = $.Event('keydown');

  event.keyCode = 82;
  $(document).trigger(event);

  ok(localStorage.getItem('peteshow') == null)
  ok($.cookie('peteshow') == null)
});

test('should fill out forms and submit when Q is pressed', function() {
  expect(1);

  var event = $.Event('keydown');

  $('form').on('submit', function() {
    ok(true, 'form submitted')
    return false;
  });

  event.keyCode = 81;
  $(document).trigger(event);
});

test('should hide when H is pressed', function() {
  var event = $.Event('keydown');

  event.keyCode = 72;
  $(document).trigger(event);

  equal(false, $('#peteshow').is(':visible'));
});

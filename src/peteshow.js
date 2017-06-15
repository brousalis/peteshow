var Peteshow = {};

Peteshow.defaults = {
  emailPrefix : 'test-',
  emailDomain : 'example.com',
  form        : '',
  blur        : false,
  cookies     : false,

  rules       : {},
  filter      : [],
  force       : {},
  reuse       : {},
  commands    : '',
  special     : function(){},
  events      : function(){},
  setValue    : function(selector, value) {
    selector.val(value);
  },
}

Peteshow.storage = {};

window.Peteshow = Peteshow;

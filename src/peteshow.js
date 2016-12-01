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
}

Peteshow.storage = {};

window.Peteshow = Peteshow;

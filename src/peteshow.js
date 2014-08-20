var Peteshow = {};

Peteshow.defaults = {
  emailPrefix : 'test-',
  emailDomain : 'example.com',
  form        : '',
  blur        : false,
  cookies     : false,

  rules       : {},
  ignore      : [],
  filter      : [],
  force       : {},
  reuse       : {},
  commands    : '',
  special     : function(){},
  events      : function(){},
}

window.Peteshow = Peteshow;

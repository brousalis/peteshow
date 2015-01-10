var Peteshow = {};

Peteshow.defaults = {
  emailPrefix : 'test-',
  emailDomain : 'example.com',
  form        : '',
  blur        : false,
  cookies     : false,

  rules       : {},
  filter      : [],
  ignore      : [],
  force       : {},
  reuse       : {},
  commands    : '',
  special     : function(){},
  events      : function(){},
}

exports = module.exports = window.Peteshow = Peteshow;

module.exports.core    = require('./peteshow-core.js');
module.exports.helpers = require('./peteshow-helpers.js');
module.exports.storage = require('./peteshow-storage.js');

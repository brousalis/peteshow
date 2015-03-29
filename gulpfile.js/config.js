var path = require('path');

var BASE_SRC_PATH       = path.join(__dirname, '../src');
var BASE_JS_PATH        = path.join(BASE_SRC_PATH, 'js');
var BASE_CSS_PATH       = path.join(BASE_SRC_PATH, 'css');
var BASE_GENERATED_PATH = path.join(__dirname, '../.generated');
var BASE_TEST_PATH      = path.join(__dirname, '../test');
var BASE_MODULES_PATH   = path.join(__dirname, '../node_modules');

module.exports = {
  input: {
    css    : path.join(BASE_CSS_PATH, 'peteshow.scss'),
    js     : path.join(BASE_JS_PATH, 'peteshow.coffee'),
    vendor : [
      path.join(BASE_MODULES_PATH, 'faker', 'build', 'build', '*'),
      path.join(BASE_MODULES_PATH, 'jquery', 'dist', '*'),
      path.join(BASE_MODULES_PATH, 'jquery.cookie', 'jquery.cookie.js'),
      path.join(BASE_MODULES_PATH, 'jquery-formatdatetime', 'jquery.formatDateTime.js')
    ]
  },

  output: {
    css    : path.join(BASE_GENERATED_PATH, 'stylesheets'),
    js     : path.join(BASE_GENERATED_PATH, 'javascripts'),
    vendor : path.join(BASE_GENERATED_PATH, 'vendor'),
  },

  watch: {
    css : [
      path.join(BASE_SRC_PATH, 'css', '**', '*.scss'),
    ],
    js  : [
      path.join(BASE_SRC_PATH, 'js', '*.coffee'),
      path.join(BASE_SRC_PATH, 'templates', '*.hbs')
    ]
  },

  browserSync: {
    proxy : 'http://localhost:3002',
    port  : 3003,
    files : path.join(BASE_GENERATED_PATH, '**', '*'),
  },

  test: {
    helper   : path.join(BASE_TEST_PATH, 'test-helper'),
    features : path.join(BASE_TEST_PATH, 'feature', '*-test.coffee')
  },

  server: path.join(BASE_TEST_PATH, 'test-server'),

  clean: [
    path.join(BASE_GENERATED_PATH, 'stylesheets', '**', '*'),
    path.join(BASE_GENERATED_PATH, 'javascripts', '**', '*'),
    path.join(BASE_GENERATED_PATH, 'vendor', '**', '*')
  ]
};

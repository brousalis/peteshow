var path = require('path');

var BASE_SRC_PATH       = path.join(__dirname, '../src');
var BASE_GENERATED_PATH = path.join(__dirname, '../.generated');
var BASE_JS_PATH        = path.join(BASE_SRC_PATH, 'js');
var BASE_CSS_PATH       = path.join(BASE_SRC_PATH, 'css');
var BASE_TEST_PATH      = path.join(__dirname, '../test');

module.exports = {
  delay: 500,

  input: {
    css    : path.join(BASE_CSS_PATH, 'peteshow.scss'),
    js     : path.join(BASE_JS_PATH, 'peteshow.coffee'),
    test   : path.join(BASE_GENERATED_PATH, 'test_index.html'),
    vendor : [
      path.join(__dirname, '../node_modules', 'qunitjs', 'qunit', '*'),
      path.join(__dirname, '../node_modules', 'faker', 'build', 'build', '*'),
      path.join(__dirname, '../node_modules', 'jquery', 'dist', '*'),
      path.join(__dirname, '../node_modules', 'jquery.cookie', 'jquery.cookie.js'),
      path.join(__dirname, '../node_modules', 'jquery-formatdatetime', 'jquery.formatDateTime.js')
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
    files : ['./.generated/**/*.*'],
  },

  test: {
    helper   : path.join(BASE_TEST_PATH, 'test-helper'),
    features : path.join(BASE_TEST_PATH, 'feature', '*-test.coffee')
  },

  server: path.join(BASE_TEST_PATH, 'test-server'),

  clean: path.join(BASE_GENERATED_PATH, '**', '*'),
};

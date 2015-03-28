var gulp = require('gulp');
var config = require('../config');

gulp.task('server', ['watch'], function() {
  coffee = require('coffee-script/register');
  server = require(config.server);
  server({port: 3002});
});

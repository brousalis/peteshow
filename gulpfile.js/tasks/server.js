var gulp = require('gulp');
var config = require('../config');

gulp.task('server', function() {
  require('coffee-script/register');
  server = require(config.server);
  server();
});

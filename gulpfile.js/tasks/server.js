var config = require('../config');
var gulp   = require('gulp');

gulp.task('server', function() {
  require('coffee-script/register');

  server = require(config.server);
  server();
});

var config = require('../config');
var gulp   = require('gulp');
var del    = require('del');

gulp.task('clean', function() {
  return del(config.clean);
});


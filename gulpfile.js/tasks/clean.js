var config = require('../config');
var gulp   = require('gulp');
var del    = require('del');

// deletes the generated files
gulp.task('clean', function() {
  return del(config.clean);
});


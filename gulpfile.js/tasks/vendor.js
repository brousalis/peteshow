var config  = require('../config');
var gulp    = require('gulp');
var plumber = require('gulp-plumber');
var flatten = require('gulp-flatten');

gulp.task('vendor', function() {
  return gulp.src(config.input.vendor)
    .pipe(plumber())
    .pipe(flatten())
    .pipe(gulp.dest(config.output.vendor));
});


var config  = require('../config');
var gulp    = require('gulp');
var gutil   = require('gulp-util');
var plumber = require('gulp-plumber');
var flatten = require('gulp-flatten');

// test : synchronize
gulp.task('test-sync', function() {
  gulp.src(config.input.testSync.src, { base: './test/'})
    .pipe(gulp.dest(config.output.testSync)
      .on('error', gutil.log)
      .on('error', gutil.beep));

  return gulp.src(config.input.testSync.vendor)
    .pipe(plumber())
    .pipe(flatten())
    .pipe(gulp.dest(config.output.vendor));
});


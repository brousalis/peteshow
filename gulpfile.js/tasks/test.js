var config = require('../config');
var gulp   = require('gulp');
var qunit  = require('gulp-qunit');
var path   = require('path');
var watch  = require('gulp-watch');

// test : qunit
gulp.task('test', function() {
  return gulp.src(config.input.test)
    .pipe(watch(config.watch.test))
    .pipe(qunit());
});


var config = require('../config');
var gulp   = require('gulp');
var watch = require('gulp-watch');

gulp.task('watch', ['pre-watch'], function() {
  watch(config.watch.css, function() {
    gulp.start('css');
  });

  watch(config.watch.js, function() {
    gulp.start('js');
  });

  watch(config.watch.testSync, function() {
    gulp.start('test-sync');
  });
});


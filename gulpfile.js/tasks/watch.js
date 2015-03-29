var config = require('../config');
var gulp   = require('gulp');
var watch  = require('gulp-watch');
var browserSync = require('browser-sync');
var reload = browserSync.reload;

gulp.task('watch', ['pre-watch', 'browser-sync'], function() {
  watch(config.watch.css, function() { gulp.start('css'); reload() });
  watch(config.watch.js, function() { gulp.start('js'); reload() });
  watch(config.test.features, function() { gulp.start('test'); });
});


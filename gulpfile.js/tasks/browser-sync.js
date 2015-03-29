var config      = require('../config');
var gulp        = require('gulp');
var browserSync = require('browser-sync');

// delay added so nodemon can spin up first
gulp.task('browser-sync', function() {
  setTimeout(function reload() {
    browserSync(config.browserSync);
  }, 1000);
});

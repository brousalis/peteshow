var config      = require('../config');
var gulp        = require('gulp');
var browserSync = require('browser-sync');

gulp.task('browser-sync', ['nodemon'], function() {
  browserSync({
    proxy: 'http://localhost:3002',
    files: ['./.generated/**/*.*'],
    browser: 'google chrome',
    port: 3003,
  });
});

var gulp    = require('gulp');
var config  = require('../config');
var nodemon = require('nodemon');
var browserSync = require('browser-sync');

gulp.task('nodemon', function (cb) {
  var called = false;

  return nodemon({
    script: './start.coffee',
    ignore: [
      "gulpfile.js/**/*",
      "app/**/*",
      ".generated/**/*",
      "start.coffee"
    ]
  })
  .on('start', function onStart() {
    // ensure start only got called once
    if (!called) { cb(); }
    called = true;
  })
  .on('restart', function onRestart() {
    // reload connected browsers after a slight delay
    setTimeout(function reload() {
      browserSync.reload({ stream: false });
    }, config.delay);
  });
});

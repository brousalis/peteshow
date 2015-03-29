var gulp    = require('gulp');
var config  = require('../config');
var nodemon = require('gulp-nodemon');
 
gulp.task('nodemon', function (cb) {
  var coffee = require('coffee-script/register')
  return nodemon({
    script: './test/test-server.coffee' 
  }).on('start', function () {
    cb();
  });
});



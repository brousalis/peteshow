var config = require('../config');
var gulp   = require('gulp');
var mocha  = require('gulp-mocha');
var path   = require('path');
var watch  = require('gulp-watch');

// mocha tests 
gulp.task('test', function() {
  require('coffee-script/register');
  require(config.test.helper);

  return gulp.src(config.test.features, {read: false})
    .pipe(mocha({ compilers: 'coffee:coffee-script' }));
});


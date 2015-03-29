var config     = require('../config');
var gulp       = require('gulp');
var browserify = require('browserify');
var plumber    = require('gulp-plumber');
var minifycss  = require('gulp-minify-css');
var uglify     = require('gulp-uglify');
var gutil      = require('gulp-util');
var sass       = require('gulp-sass');
var source     = require('vinyl-source-stream');
var buffer     = require('vinyl-buffer');
var coffeeify  = require('coffeeify');
var sourcemaps = require('gulp-sourcemaps');
var rename     = require('gulp-rename');

gulp.task('uglify', ['css', 'js'], function() {
  var jsStream = browserify(config.input.js, {
      extensions: ['.coffee'],
      debug: true
    })
    .transform('coffeeify')
    .transform('hbsfy')
    .bundle()
    .on('error', gutil.log)
    .on('error', gutil.beep);

  // minified css
  return gulp.src(config.input.css)
    .pipe(plumber())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(sass()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(rename({suffix: '.min'}))
    .pipe(minifycss()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.output.css))

  // minified js
  jsStream
    .pipe(plumber())
    .pipe(source(config.input.js))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(uglify({compress: { negate_iife: false }})
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(rename('peteshow.min.js'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.output.js));

  return jsStream;

});

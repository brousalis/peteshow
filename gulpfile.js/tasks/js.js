var config     = require('../config');
var gulp       = require('gulp');
var browserify = require('browserify');
var plumber    = require('gulp-plumber');
var uglify     = require('gulp-uglify');
var gutil      = require('gulp-util');
var source     = require('vinyl-source-stream');
var buffer     = require('vinyl-buffer');
var coffeeify  = require('coffeeify');
var sourcemaps = require('gulp-sourcemaps');
var rename     = require('gulp-rename');

gulp.task('js', function() {
  var jsStream = browserify(config.input.js, {
      extensions: ['.coffee'],
      debug: true
    })
    .transform('coffeeify')
    .transform('hbsfy')
    .bundle()
    .on('error', gutil.log)
    .on('error', gutil.beep);

  // standard code
  jsStream
    .pipe(plumber())
    .pipe(source(config.input.js))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(rename('peteshow.js'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.output.js));

  // minified code
  jsStream
    .pipe(plumber())
    .pipe(source(config.input.js))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(uglify({ compress: { negate_iife: false }})
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(rename('peteshow.min.js'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.output.js));
});


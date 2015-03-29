var config     = require('../config');
var gulp       = require('gulp');
var plumber    = require('gulp-plumber');
var minifycss  = require('gulp-minify-css');
var sourcemaps = require('gulp-sourcemaps');
var sass       = require('gulp-sass');
var gutil      = require('gulp-util');
var rename     = require('gulp-rename');
var browserSync = require('browser-sync');
var reload = browserSync.reload;

gulp.task('css', function() {
  // regular css
  gulp.src(config.input.css)
    .pipe(plumber())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(sass()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.output.css))
    .pipe(reload({stream: true}));

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
    .pipe(reload({stream: true}));
});

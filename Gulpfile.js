// Gulpfile.js
// Require the needed packages
var browserify   = require('browserify'),
    colors       = require('colors'),
    del          = require('del'),
    gulp         = require('gulp'),
    gutil        = require('gulp-util'),
    marked       = require('marked'),
    minifycss    = require('gulp-minify-css'),
    path         = require('path'),
    plumber      = require('gulp-plumber'),
    qunit        = require('gulp-qunit')
    rename       = require('gulp-rename'),
    runSequence  = require('run-sequence'),
    sass         = require('gulp-sass'),
    source       = require('vinyl-source-stream'),
    sourcemaps   = require('gulp-sourcemaps'),
    streamify    = require('gulp-streamify'),
    uglify       = require('gulp-uglify'),
    watch        = require('gulp-watch');

// Base paths
var BASE_SRC_PATH    = path.join(__dirname, 'src'),
    BASE_DIST_PATH   = path.join(__dirname, 'dist'),
    BASE_LIB_PATH    = path.join(__dirname, 'lib'),
    BASE_JS_PATH     = path.join(BASE_SRC_PATH, 'js'),
    BASE_CSS_PATH    = path.join(BASE_SRC_PATH, 'css');

// Task paths
var paths = {
  input: {
    css: path.join(BASE_SRC_PATH, 'css', 'peteshow.scss'),

    js: {
      vendor: [
        'jquery',
        'jquery.cookie',
        'jquery-formatdatetime',
        'faker'
      ],

      src: [
        path.join(BASE_SRC_PATH, 'peteshow.js'),
        path.join(BASE_SRC_PATH, 'peteshow-helpers.js'),
        path.join(BASE_SRC_PATH, 'peteshow-storage.js'),
        path.join(BASE_SRC_PATH, 'peteshow-core.js')
      ]
    },

    dist: [
      path.join(BASE_LIB_PATH, 'assets', '**', '*.js'),
      path.join(BASE_LIB_PATH, 'assets', '**', '*.css')
    ],
  },

  output: {
    css : path.join(BASE_LIB_PATH, 'assets', 'stylesheets'),
    js  : path.join(BASE_LIB_PATH, 'assets', 'javascripts'),
    dist: BASE_DIST_PATH
  },

  watch: {
    css : path.join(BASE_SRC_PATH, 'css', '**', '*.scss'),
    js  : path.join(BASE_SRC_PATH, '*.js')
  },

  clean: [
    path.join(BASE_DIST_PATH, '**', '*'),
    path.join(BASE_LIB_PATH, 'assets', '**', '*')
  ],

  test: [ 'tests/index.html' ]
};

// test : qunit
gulp.task('test', function() {
  return gulp.src('./tests/index.html')
    .pipe(qunit());
});

//
// css
gulp.task('css', function() {
  return gulp.src(paths.input.css)
    .pipe(plumber())
    .pipe(sourcemaps.init())
    .pipe(sass()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(paths.output.css))
    .pipe(rename({suffix: '.min'}))
    .pipe(minifycss()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.output.css));
});

//
// js
gulp.task('js', function() {
  var jsStream = browserify(paths.input.js.src)
    .require(paths.input.js.vendor)
    .bundle()

  return jsStream
    .pipe(plumber())
    .pipe(source(paths.input.js.src[0]))
    .pipe(rename('peteshow.js'))
    .pipe(gulp.dest(paths.output.js))
    .pipe(rename({suffix:'.min'}))
    .pipe(streamify(uglify())
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.output.js));
});

//
// Dist
gulp.task('dist', function() {
  return gulp.src(paths.input.dist, {base: BASE_DIST_PATH})
    .pipe(rename({dirname: ''}))
    .pipe(gulp.dest(paths.output.dist));
});

//
// Clean
gulp.task('clean', function() {
  return del(paths.clean, { sync: true });
});

//
// Watch
gulp.task('watch', ['default'], function() {
  watch(paths.watch.css, function(files, cb) {
    gulp.start('css', cb);
  });
  watch(paths.watch.js, function(files, cb) {
    gulp.start('js', cb);
  });
});

//
// Default
gulp.task('default', function(callback) {
  runSequence('clean', ['css', 'js'], 'dist', 'test', callback);
});

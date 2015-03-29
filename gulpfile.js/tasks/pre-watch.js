var gulp = require('gulp');
var runSequence = require('run-sequence');

gulp.task('pre-watch', function(callback) {
  runSequence('clean', 'css', 'js', 'vendor', callback);
});


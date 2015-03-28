var gulp = require('gulp');
var runSequence = require('run-sequence');

gulp.task('default', function(callback) {
  runSequence('clean', 'css', 'js', 'vendor', 'test-sync', 'test', callback);
});


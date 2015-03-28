var gulp = require('gulp');

gulp.task('dist', function() {
  return gulp.src(paths.input.dist, {base: BASE_DIST_PATH})
    .pipe(rename({dirname: ''}))
    .pipe(gulp.dest(paths.output.dist));
});

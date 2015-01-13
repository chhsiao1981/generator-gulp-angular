gulp = require 'gulp'

$ = (require 'gulp-load-plugins')!

wiredep = require 'wiredep'

paths = gulp.paths

run-tests = (single-run, done) ->
  bower-deps = wiredep do
    directory: 'bower_components',
    exclude: <[ bootstrap-sass-official ]>
    dependencies: true,
    dev-dependencies: true

  test-files = [
    paths.tmp + '/**/*.js'
    '!' + paths.tmp + '/**/*_test.js'
  ]

  gulp.src test-files
    .pipe $.angular-filesort!
    .pipe $.add-src.prepend bower-deps.js
    .pipe $.add-src.append paths.src + '/**/*_test.ls'
    .pipe $.karma do
      config-file: 'karma.conf.ls',
      action: if single-run then 'run' else 'watch'
    .on 'error', (err) ->
      # Make sure failed tests cause gulp to exit non-zero
      throw err;

<% if (props.jsPreprocessor.key === 'none') { %>
gulp.task 'test', (done) -> run-tests true, done
gulp.task 'test:auto', (done) -> run-tests false, done
< % } else if (props.jsPreprocessor.extension === 'js') { %>
gulp.task 'test', <[ browserify ]> (done) -> run-tests true, done
gulp.task 'test:auto', <[ browserify ]> (done) -> run-tests false, done
<% } else { %>
gulp.task 'test', <[ scripts ]> (done) -> run-tests true, done
gulp.task 'test:auto', <[ scripts ]> (done) -> run-tests false, done
<% } %>

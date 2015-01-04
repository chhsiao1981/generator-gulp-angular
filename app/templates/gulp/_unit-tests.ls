gulp = require 'gulp'

$ = (require 'gulp-load-plugins')!

wiredep = require 'wiredep'

run-tests = (single-run, done) ->
  bower-deps = wiredep do
    directory: 'bower_components',
    exclude: <[ bootstrap-sass-official ]>
    dependencies: true,
    devDependencies: true

  test-files = bower-deps.js.concat [
    '.tmp/{app,components}/**/*.js'
    '.tmp/{app,components}/**.spec.js',
    '.tmp/{app,components}/**.mock.js'
  ]

  gulp.src test-files
    .pipe $.karma do
      config-file: 'karma.conf.ls',
      action: if single-run then 'run' else 'watch'
    .on 'error', (err) ->
      # Make sure failed tests cause gulp to exit non-zero
      throw err;
<% if (props.jsPreprocessor.key === 'none') { %>
gulp.task 'test', (done) -> run-tests true, done
gulp.task 'test:auto', (done) -> run-tests true, done < % } else if (props.jsPreprocessor.extension === 'js') { %>
gulp.task 'test', <[ browserify ]> (done) -> run-tests true, done
gulp.task 'test:auto', <[ browserify ]> (done) -> run-tests true, done <% } else { %>
gulp.task 'test', <[ scripts ]> (done) -> run-tests true, done
gulp.task 'test:auto', <[ scripts ]> (done) -> run-tests true, done <% } %>

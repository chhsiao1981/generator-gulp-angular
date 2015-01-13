gulp = require 'gulp'

paths = gulp.paths

$ = (require 'gulp-load-plugins')!
jshintrc = require '../.jshintrc'
jshintrc.boss = true

gulp.task 'scripts' ->
  gulp.src paths.src + '/**/*.ls'
    .pipe $.livescript {bare: true}
    .pipe $.wrap '(function(){\n\'use strict\';\n<%= "\<%= contents %\>" %>\n})();'
    .pipe $.jshint jshintrc
    .pipe $.jshint.reporter 'jshint-stylish'
    .on 'error', (err) ->
      console.error err.to-string!
      @emit 'end'
    .pipe gulp.dest paths.tmp
    .pipe $.size!

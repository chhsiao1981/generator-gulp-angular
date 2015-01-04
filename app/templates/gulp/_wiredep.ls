gulp = require 'gulp'

paths = gulp.paths

# inject bower components
gulp.task 'wiredep', ->
  wiredep = require 'wiredep' .stream

  gulp.src paths.src + '/index.html'
    .pipe wiredep do
      directory: 'bower_components'<% if(wiredepExclusions.length) { %>,
      exclude: <[ <%= wiredepExclusions.join(' ') %> ]><% } %>
    .pipe gulp.dest paths.src

gulp = require 'gulp'

paths = gulp.paths

# inject bower components
gulp.task 'wiredep', <[ index-to-tmp ]> ->
  wiredep = require 'wiredep' .stream

  gulp.src paths.tmp + '/index.<%= props.htmlPreprocessor.extension %>'
    .pipe wiredep do
      directory: 'bower_components'<% if(wiredepExclusions.length) { %>,
      exclude: <[ <%= wiredepExclusions.join(' ') %> ]><% } %>
    .pipe gulp.dest paths.tmp

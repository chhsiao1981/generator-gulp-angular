'use strict'

gulp = require 'gulp'

gulp.paths =
  src: '<%= props.paths.src %>'
  dist: '<%= props.paths.dist %>'
  tmp: '<%= props.paths.tmp %>'
  e2e: '<%= props.paths.e2e %>'

(require 'require-dir') './gulp'

gulp.task 'default', <[ clean ]>, ->
  gulp.start 'build'

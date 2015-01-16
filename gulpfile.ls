gulp = require 'gulp'

through = require 'through2'

gulp-livescript = require 'gulp-livescript'

dirs = <[ bp constant component controller directive factory filter general module provider service value view ]>

srcs = './{' + (dirs.join ',') + '}/**/*.ls'
src-dirs = './{' + (dirs.join ',') + '}/**/'
template-srcs = './{' + (dirs.join ',') + '}/templates/**'

console.log('srcs:', srcs)

gulp.task 'watch', <[ scripts ]> ->
  gulp.watch [
    srcs
    '!' + template-srcs
  ], <[ scripts ]>

gulp.task 'scripts' ->
  gulp.src [
    srcs
    '!' + template-srcs
  ]
    .pipe gulp-livescript!
    .pipe gulp.dest '.'

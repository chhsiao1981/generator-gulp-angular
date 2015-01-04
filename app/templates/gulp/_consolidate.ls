consolidate = require 'gulp-consolidate'
rename = require 'gulp-rename'
gulp = require 'gulp'

engines = [
  <%= consolidateParameters.join('\n  ') %>
]

build-templates = (engine, src, dest) ->
  gulp.src src
    .pipe consolidate.apply @, engine
    .pipe rename (path) -> path.extname = '.html'
    .pipe gulp.dest dest

build-task-function = (engine) ->
  ->
    build-templates engine, 'src/app/**/*.jade', '.tmp/app/'
    build-templates engine, 'src/components/**/*.jade', '.tmp/components/'

_set-task = (engine) ~>
  gulp.task 'consolidate:' + engine[0] + ':app', build-templates.bind @, engine, 'src/app/**/*.jade', '.tmp/app/'
  gulp.task 'consolidate:' + engine[0] + ':components', build-templates.bind @, engine, 'src/components/**/*.jade', '.tmp/components/'
  gulp.task 'consolidate:' + engine[0], ['consolidate:' + engine[0] + ':app', 'consolidate:' + engine[0] + ':components']

  'consolidate:' + engine[0]

tasks = [_set-task engine for engine in engines]

gulp.task 'consolidate', tasks

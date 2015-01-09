gulp = require 'gulp'

paths = gulp.paths

$ = (require 'gulp-load-plugins')!

gulp.task 'markups', ->
  rename-to-html = (path) !-> path.extname = '.html'

  gulp.src [
    paths.src + '/**/*.<%= props.htmlPreprocessor.extension %>'
    '!' + paths.src + '/index.<%= props.htmlPreprocessor.extension %>'
  ]
<% if (props.htmlPreprocessor.key === 'jade') { %>
    .pipe $.consolidate 'jade', {pretty: '  '}
<% } else if (props.htmlPreprocessor.key === 'haml') { %>
    .pipe $.consolidate 'hamljs'
<% } else if (props.htmlPreprocessor.key === 'handlebars') { %>
    .pipe $.consolidate 'handlebars'
<% } %>
    .on 'error', (err) ->
      console.log err.to-string!
      @emit 'end'
    .pipe $.rename rename-to-html
    .pipe gulp.dest paths.tmp

gulp.task 'index-to-tmp', ->
  gulp.src [
    paths.src + '/index.<%= props.htmlPreprocessor.extension %>'
  ]
    .pipe gulp.dest paths.tmp

gulp.task 'index-to-html', <[ inject ]> ->
  rename-to-html = (path) !-> path.extname = '.html'

  gulp.src [
    paths.tmp + '/index.<%= props.htmlPreprocessor.extension %>'
  ] 
<% if (props.htmlPreprocessor.key === 'jade') { %>
    .pipe $.consolidate 'jade', {pretty: '  '}
<% } else if (props.htmlPreprocessor.key === 'haml') { %>
    .pipe $.consolidate 'hamljs'
<% } else if (props.htmlPreprocessor.key === 'handlebars') { %>
    .pipe $.consolidate 'handlebars'
<% } %>
    .pipe $.rename rename-to-html
    .pipe gulp.dest paths.tmp

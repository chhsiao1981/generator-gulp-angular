gulp = require 'gulp'

paths = gulp.paths

$ = (require 'gulp-load-plugins')!

gulp.task 'styles' ->
<% console.log('cssPreprocessor:', props.cssPreprocessor); if (props.cssPreprocessor.key === 'less') { %>
  less-options = 
    paths: [
      'bower_components'
      paths.src + '/**'
    ]
<% } if (props.cssPreprocessor.extension === 'scss') { %>
  sass-options =
    style: 'expanded'
<% } %>

  inject-files = gulp.src [
    paths.src + '/**/*.<%= props.cssPreprocessor.extension %>'
    '!' + paths.src + '/index.<%= props.cssPreprocessor.extension %>'
    '!' + paths.src + '/vendor.<%= props.cssPreprocessor.extension %>'
  ], {read: false}

  inject-options =
    transform: (file-path) ->
      file-path = file-path.replace paths.src + '/components/', '../components'
      file-path = file-path.replace paths.src, ''
      '@import \'' + file-path + '\';'

    starttag: '// injector'
    endtag: '// endinjector'
    add-root-slash: false

  index-filter = $.filter 'index.<%= props.cssPreprocessor.extension %>'

  gulp.src [
    paths.src + '/index.<%= props.cssPreprocessor.extension %>'
    paths.src + '/vendor.<%= props.cssPreprocessor.extension %>'
  ]
    .pipe index-filter
    .pipe $.inject inject-files, inject-options
    .pipe index-filter.restore!
<% if (props.cssPreprocessor.key === 'less') { %>
    .pipe $.less!
<% } else if (props.cssPreprocessor.key === 'ruby-sass') { %>
    .pipe $.ruby-sass sass-options
<% } else if (props.cssPreprocessor.key === 'node-sass') { %>
    .pipe $.sass sass-options
<% } else if (props.cssPreprocessor.key === 'stylus') { %>
    .pipe $.stylus!
<% } %>
    .pipe $.autoprefixer!
      .on 'error', (err) ->
        console.error err.to-string!
        @emit 'end'
    .pipe gulp.dest paths.tmp

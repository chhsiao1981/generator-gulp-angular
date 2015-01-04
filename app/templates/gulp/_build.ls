gulp = require 'gulp'
gulp-livescript = require 'gulp-livescript'

$ = (require 'gulp-load-plugins') do
  pattern: <[ gulp-* main-bower-files uglify-save-license del ]>

paths = gulp.paths
<% if (props.cssPreprocessor.key !== 'none') { %>
gulp.task 'styles', <[ wiredep injector:css:preprocessor ]>, ->
  gulp.src [paths.src + '/app/index.<%= props.cssPreprocessor.extension %>', paths.src + '/app/vendor.<%= props.cssPreprocessor.extension %>']<% if (props.cssPreprocessor.key === 'less') { %>
    .pipe $.less {paths: <[ src/bower_components src/app src/components ]>}<% } else if (props.cssPreprocessor.key === 'ruby-sass') { %>
    .pipe $.ruby-sass {style: 'expanded'}<% } else if (props.cssPreprocessor.key === 'node-sass') { %>
    .pipe $.sass {style: 'expanded'}<% } else if (props.cssPreprocessor.key === 'stylus') { %>
    .pipe $.stylus!<% } %>
    .on 'error', (err) ->
      console.error err.to-string!
      this.emit 'end'
    .pipe $.autoprefixer!
    .pipe gulp.dest paths.tmp + '/app/'

gulp.task 'injector:css:preprocessor', ->
  gulp.src paths.src + '/app/index.<%= props.cssPreprocessor.extension %>'
    .pipe $.inject (gulp.src [
      paths.src + '/{app,components}/**/*.<%= props.cssPreprocessor.extension %>'
      '!' + paths.src + '/app/index.<%= props.cssPreprocessor.extension %>'
      '!' + paths.src + '/app/vendor.<%= props.cssPreprocessor.extension %>'
    ], {read: false}), do
      transform: (file-path) ->
        file-path = file-path.replace paths.src + '/app/', ''
        file-path = file-path.replace paths.src + '/components/', '../components'
        '@import \'' + file-path + '\';'
      starttag: '// injector'
      endtag: '// endinjector'
      add-root-slash: false
    .pipe gulp.dest paths.src + '/app/'
<% } %>

gulp.task 'injector:css', <[ <% if (props.cssPreprocessor.key !== 'none') { %>styles<% } else { %>wiredep<% } %> ]>, -> 
  gulp.src paths.src + '/index.html'
    .pipe $.inject (gulp.src [<% if (props.cssPreprocessor.key !== 'none') { %>
      paths.tmp + '/{app,components}/**/*.css'
      '!' + paths.tmp + '/app/vendor.css' <% } else { %>
      paths.src + '/{app,components}/**/*.css'<% } %>
    ], {read: false}), do
      ignore-path: <% if (props.cssPreprocessor.key !== 'none') { %>paths.tmp<% } else { %>paths.src<% } %>
      add-root-slash: false
    .pipe gulp.dest paths.src + '/'

gulp.task 'scripts', ->
  gulp.src paths.src + '/{app,components}/**/*.ls'
    .pipe $.livescript {bare: true}
    .pipe $.wrap '(function(){\n\'use strict\';\n<%= "\<%= contents %\>" %>\n})();'
    .on 'error', (err) ->
      console.error err.to-string!
      this.emit 'end'
    .pipe $.jshint!
    .pipe $.jshint.reporter 'jshint-stylish'
    .pipe gulp.dest paths.tmp + '/'
    .pipe $.size!

gulp.task 'injector:js' <[ scripts injector:css ]> ->
  gulp.src [paths.src + '/index.html', paths.tmp + '/index.html']
    .pipe $.inject (gulp.src [
      '{' + paths.src + ',' + paths.tmp + '}/{app,components}/**/*.js'
      '!{' + paths.src + ',' + paths.tmp + '}/{app,components}/**/*.spec.js'
      '!{' + paths.src + ',' + paths.tmp + '}/{app,components}/**/*.mock.js'
      ] .pipe $.angular-filesort!), {ignore-path: [paths.src, paths.tmp], add-root-slash: false}
    .pipe gulp.dest paths.src + '/'

gulp.task 'partials', <% if (!_.isEmpty(props.htmlPreprocessors)) { %><[ consolidate ]>, <% } %> ->
  gulp.src [paths.src + '/{app,components}/**/*.html', paths.tmp + '/{app,components}/**/*.html']
    .pipe $.minify-html do
      empty: true,
      spare: true,
      quotes: true
    .pipe $.angular-templatecache 'templateCacheHtml.js', do
      module: '<%= appName %>'
    .pipe gulp.dest '.tmp/inject/'
    .pipe $.size!

gulp.task 'html', <[ wiredep injector:css injector:js partials ]>, ->
  html-filter = $.filter '*.html'
  js-filter = $.filter '**/*.ls'
  css-filter = $.filter '**/*.css'

  gulp.src [paths.src + '/*.html', paths.tmp + '/*.html']
    .pipe $.inject (gulp.src paths.tmp + '/inject/templateCacheHtml.js', {read: false}), do
      starttag: '<!-- inject:partials -->'
      ignore-path: paths.tmp
      add-root-slash: false
    .pipe assets = $.useref.assets!
    .pipe $.rev!
    .pipe js-filter
    .pipe $.ng-annotate!
    .pipe $.uglify {preserve-comments: $.uglify-save-license}
    .pipe js-filter.restore!
    .pipe css-filter<% if (props.ui.key === 'bootstrap' && props.cssPreprocessor.extension === 'scss') { %>
    .pipe $.replace '<%= computedPaths.appToBower %>/bower_components/bootstrap-sass-official/assets/fonts/bootstrap', '../fonts'<% } else if (props.ui.key === 'bootstrap' && props.cssPreprocessor.extension === 'less') { %>
    .pipe $.replace '<%= computedPaths.appToBower %>/bower_components/bootstrap/fonts', '../fonts' <% } %>
    .pipe $.csso!
    .pipe css-filter.restore!
    .pipe assets.restore!
    .pipe $.useref!
    .pipe $.rev-replace!
    .pipe html-filter
    .pipe $.minify-html do
      empty: true
      spare: true
      quotes: true
    .pipe html-filter.restore!
    .pipe gulp.dest paths.dist + '/'
    .pipe $.size {title: paths.dist + '/', show-files: true}

gulp.task 'images', ->
  gulp.src paths.src + '/assets/images/**/*'
    .pipe $.imagemin do
      optimization-level: 3
      progressive: true
      interlaced: true
    .pipe gulp.dest paths.dist + '/assets/images/'
    .pipe $.size!

gulp.task 'fonts', ->
  gulp.src $.main-bower-files!
    .pipe $.filter '**/*.{eot,svg,ttf,woff}'
    .pipe $.flatten!
    .pipe gulp.dest paths.dist + '/fonts/'
    .pipe $.size!

gulp.task 'misc', ->
  gulp.src 'src/**/*.ico'
    .pipe gulp.dest paths.dist + '/'
    .pipe $.size!

gulp.task 'clean', (done) ->
  $.del [paths.dist + '/', paths.tmp + '/'], done

gulp.task 'build', <[ html images fonts misc ]>

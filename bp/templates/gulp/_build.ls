gulp = require 'gulp'

paths = gulp.paths

$ = (require 'gulp-load-plugins') do
  pattern: <[ gulp-* main-bower-files uglify-save-license del ]>

<% if (props.htmlPreprocessor.key === 'none') { %>
gulp.task 'partials', ->
<% } else { %>
gulp.task 'partials', <[ markups ]>, ->
<% } %>
  gulp.src [
    paths.tmp + '/**/*.html'
    '!' + paths.tmp + '/index.html'
  ]
    .pipe $.minify-html do
      empty: true,
      spare: true,
      quotes: true
    .pipe $.angular-templatecache 'templateCacheHtml.js', do
      module: '<%= appName %>'
    .pipe gulp.dest paths.tmp + '/partials/'
    .pipe $.size!

gulp.task 'html', <[ inject partials ]>, ->
  html-filter = $.filter '*.html'
  js-filter = $.filter '**/*.js'
  css-filter = $.filter '**/*.css'
  var assets

  gulp.src [paths.tmp + '/*.html']
    .pipe assets = $.useref.assets!
    .pipe $.rev!
    .pipe js-filter
    .pipe $.ng-annotate!
    .pipe $.uglify {preserve-comments: $.uglify-save-license}
    .pipe js-filter.restore!
    .pipe css-filter
<% if (props.ui.key === 'bootstrap' && props.cssPreprocessor.extension === 'scss') { %>
    .pipe $.replace '<%= computedPaths.appToBower %>/bower_components/bootstrap-sass-official/assets/fonts/bootstrap', '../fonts'
<% } else if (props.ui.key === 'bootstrap' && props.cssPreprocessor.extension === 'less') { %>
    .pipe $.replace '<%= computedPaths.appToBower %>/bower_components/bootstrap/fonts', '../fonts'
<% } %>
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
  gulp.src paths.src + '/assets/images/**/*'<% if (imageMin) { %>
    .pipe $.imagemin do
      optimization-level: 3
      progressive: true
      interlaced: true<% } %>
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

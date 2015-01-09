gulp = require 'gulp'

paths = gulp.paths

<% if (props.htmlPreprocessor.key === 'none') { %>
gulp.task 'watch', <[ index-to-html inject ]>, ->
<% } else { %>
gulp.task 'watch', <[ index-to-html markups inject ]> ->
<% } %>
  gulp.watch [
    paths.src + '/**/*.<%= props.cssPreprocessor.extension %>'
    paths.src + '/**/*.{js,<%= props.jsPreprocessor.extension %>}'
    'bower.json'
  ], <[ inject ]>
<% if (props.htmlPreprocessor.key !== 'none') { %>
  gulp.watch [
    paths.src + '/**/*.<%= props.htmlPreprocessor.extension %>'
    '!' + paths.src + '/index.<%= props.htmlPreprocessor.extension %>'
  ], <[ markups ]>
<% } %>
  gulp.watch paths.src + '/index.<%= props.htmlPreprocessor.extension %>', <[ index-to-html ]>

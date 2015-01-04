gulp = require 'gulp'

paths = gulp.paths

gulp.task 'watch', <[ <% if (!_.isEmpty(props.htmlPreprocessors)) { %>consolidate <% } %>wiredep injector:css injector:js ]>, ->
  gulp.watch paths.src + '/{app,components}/**/*.<%= props.cssPreprocessor.extension %>', <[ injector:css ]>
  gulp.watch paths.src + '/{app,components}/**/*.{js,<%= props.jsPreprocessor.extension %>}', <[ injector:js ]>
  gulp.watch 'src/assets/images/**/*', <[ images ]>
  gulp.watch 'bower.json', <[ wiredep ]><% _.forEach(consolidateExtensions, function(extension) { %>
  gulp.watch paths.src + '/{app,components}/**/*.<%= extension %>', <[ consolidate:<%= extension %> ]><% }); %>

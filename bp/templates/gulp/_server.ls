gulp = require 'gulp'

util = require 'util'

browser-sync = require 'browser-sync'

middleware = require './proxy'

browser-sync-init = (base-dir, files, browser) ->
  browser = if browser? then 'default' else browser

  routes = null
  if base-dir == 'src' or util.is-array base-dir and base-dir.index-of 'src' != -1
    routes =
      '/bower_components': 'bower_components'

  browser-sync.instance = browser-sync.init files, do
    start-path: '/',
    server:
      base-dir: base-dir,
      middleware: middleware,
      routes: routes
    browser: browser

gulp.task 'serve', <[ watch ]>, ->
  browser-sync-init <[ src .tmp ]>, [
    '.tmp/**/*.css'
    '.tmp/**/*.js'
    'src/assets/images/**/*'
    '.tmp/*.html'
    '.tmp/**/*.html'
  ]

gulp.task 'serve:dist', <[ build ]>, ->
  browser-sync-init 'dist'

gulp.task 'serve:e2e', <[ wiredep injector:js injector:css ]>, ->
  browser-sync-init <[ src .tmp ]>, null, []

gulp.task 'serve:e2e-dist', <[ watch ]>, ->
  browser-sync-init 'dist', null, []

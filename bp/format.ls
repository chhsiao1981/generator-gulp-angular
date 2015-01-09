path = require 'path'
files = require './files.json'
fs = require 'fs'

module.exports = ->
  _ = @_

  # Retrieve props stored in .yo-rc.json
  if @skip-config
    @props = @config.get 'props'

  # Format appName
  @app-name = @app-name || path.basename process.cwd!
  @app-name = @_.camelize @_.slugify @_.humanize @app-name

  # Format paths
  @computed-paths = 
    app-to-bower: path.relative @props.paths.src, ''

  @include-modernizr = true
  @image-min = true
  @qr-code = true

  console.log 'format: advanced-features:', @props.advanced-features

  if @props.advanced-features
    @include-modernizr = (@props.advanced-features.index-of 'modernizr') >= 0
    @image-min = (@props.advanced-features.index-of 'imagemin') >= 0
    @qr-code = (@props.advanced-features.index-of 'qrCode') >= 0

  # Format list ngModules included in AngularJS DI
  ng-modules = @props.angular-modules.map (module) -> module.module

  ng-modules = _.flatten [
    ng-modules
    @props.resource.module
    @props.router.module
    @props.ui.module
    @props.bootstrap-components.module
  ]

  @modules-dependencies = _.chain ng-modules
    .filter _.is-string
    .map (dependency) -> '\'' + dependency + '\''
    .value-of!
    .join ', '

  @modules-dependencies-ls = @modules-dependencies.replace /, /g, ' ' .replace /'/g, ''

  # Format list techs used to generate app included in main view of sample
  list-techs = require './techs.json'

  used-techs = [
    'angular'
    'browsersync'
    'gulp'
    'jasmine'
    'karma'
    'protractor'
    @props.jQuery.name
    @props.ui.key
    @props.bootstrap-components.key
    @props.css-preprocessor.key
    @props.js-preprocessor.key
    @props.html-preprocessor.key
  ]
    .filter _.is-string
    .filter (tech) -> tech != 'default' and tech != 'css' and tech != 'official' and tech != 'none'

  techs-content = _.map used-techs, (value) -> list-techs[value]

  @technologies = JSON.stringify techs-content, null, 2
    .replace /'/g, '\\\''
    .replace /"/g, '\''
    .replace /\n/g, '\n    '

  @technologies-logo-copies = _.map used-techs, (value) -> 'src/assets/images/' + list-techs[value].logo

  file-templates = {}
  @partial-copies = {}

  # app.ls
  app-src = 'src/app/_index.' + @props.js-preprocessor.src-extension
  file-templates[app-src] = 'src/app.' + @props.js-preprocessor.extension

  # app-controller.ls (Need to replace MainCtrl to AppCtrl)
  app-controller-src = 'src/app/main/_main.controller.' + @props.js-preprocessor.src-extension
  file-templates[app-controller-src] = 'src/app-controller.' + @props.js-preprocessor.extension

  # app-controller_test.ls (need to replace MainCtrl to AppCtrl)
  app-controller-src = 'src/app/main/_main.controller.spec.' + @props.js-preprocessor.src-extension
  file-templates[app-controller-src] = 'src/app-controller_test.' + @props.js-preprocessor.extension

  # app.jade (need to replace components/navbar/navbar.html to navbar.html)
  router-partial-src = 'src/app/main/__' + @props.ui.key + '.' + @props.html-preprocessor.extension
  if @props.router.module
    @partial-copies[router-partial-src] = 'src/app.' + @props.html-preprocessor.extension

  # Compute routing relative to props.router
  if @props.router.module == 'ngRoute'
    @router-html = '<div ng-view></div>'
    @router-jade = 'div(ng-view)'
    @router-js = @read 'src/app/__ngroute.' + @props.js-preprocessor.extension, 'utf8' .replace('MainCtrl', 'AppCtrl') .replace('app/main/main.html', 'app.html')
  else if @props.router.module == 'ui.router'
    @router-html = '<div ui-view></div>'
    @router-jade = 'div(ui-view)'
    @router-js = @read 'src/app/__uirouter.' + @props.js-preprocessor.extension, 'utf8' .replace('MainCtrl', 'AppCtrl') .replace('app/main/main.html', 'app.html')
  else
    @router-html = @read router-partial-src, 'utf8' .replace('components/navbar/navbar.html', 'navbar.html')
    @router-html = @router-html.replace /^<div class="container">/, '<div class="container" ng-controller="AppCtrl">'
    @router-html = @router-html.replace(/\n/g, '\n    ');
    @router-jade = @read router-partial-src, 'utf8' .replace 'components/navbar/navbar.html', 'navbar.html'
    @router-jade = @router-jade.replace /^div.container/, 'div.container(ng-controller="AppCtrl")'
    @router-jade = @router-jade.replace /\n/g, '\n    '
    @routerJs = ''

  # navbar.jade
  navbar-partial-src = 'src/components/navbar/__' + @props.ui.key + '-navbar.' + @props.html-preprocessor.extension
  @partial-copies[navbar-partial-src] = 'src/navbar.' + @props.html-preprocessor.extension

  # navbar.ls
  navbar-controller-src = 'src/components/navbar/_navbar.controller.' + @props.js-preprocessor.src-extension
  file-templates[navbar-controller-src] = 'src/navbar-controller.' + @props.js-preprocessor.extension

  # inject task dependencies
  @inject-task-deps = <[ partials ]>

  if @props.css-preprocessor.key != 'none' then @inject-task-deps.push "'styles'"

  if @props.js-preprocessor.key != 'none' then 
    if @props.js-preprocessor.extension == 'js'
      @inject-task-deps.push "'browserify'"
    else
      @inject-task-deps.push "'scripts'"
  @inject-task-deps-ls = [each-dep.replace /\'/g, '' for each-dep in @inject-task-deps]

  # Wiredep exclusions
  @wiredep-exclusions = []

  if @props.ui.key == 'bootstrap'
    if @props.bootstrap-components.key != 'official'
      if @props.css-preprocessor.extension == 'scss'
        @wiredep-exclusions.push '/bootstrap-sass-official/'
      else
        @wiredep-exclusions.push '/bootstrap\\.js/'

    if @props.css-preprocessor.key != 'none'
      @wiredep-exclusions.push '/bootstrap\\.css/'
  else if @props.ui.key == 'foundation'
    if @props.foundation-components.key != 'official'
      @wiredep-exclusions.push '/foundation\\.js/'

    if @props.css-preprocessor.key != 'none'
      @wiredep-exclusions.push '/foundation\\.css/'

  if @props.css-preprocessor.key != 'none'
    @wiredep-exclusions.push '/bootstrap\\.css/'
    @wiredep-exclusions.push '/foundation\\.css/'

  # Format choice UI Framework
  if @props.ui.key.index-of 'bootstrap' != -1 and @props.css-preprocessor.extension != 'scss'
    @props.ui.name = 'bootstrap'

  console.log 'after format choice ui framework: props.ui:', @props.ui

  @style-copies = {}

  # index.scss
  style-app-src = 'src/app/__' + @props.ui.key + '-index.' + @props.css-preprocessor.extension
  @style-copies[style-app-src] = 'src/index.' + @props.css-preprocessor.extension

  # There is 2 ways of dealing with vendor styles
  # - If the vendor styles exist in the css preprocessor chosen,
  #   the best is to include directly the source files
  # - If not, the vendor styles are simply added as standard css links
  #
  # isVendorStylesPreprocessed defines which solution has to be used
  # regarding the ui framework and the css preprocessor chosen.

  @is-vendor-styles-preprocessed = false;

  if @props.css-preprocessor.extension == 'scss'
    if @props.ui.key == 'bootstrap' or @props.ui.key == 'foundation'
      @is-vendor-styles-preprocessed = true
  else if @props.css-preprocessor.extension == 'less'
    if @props.ui.key == 'bootstrap'
      @is-vendor-styles-preprocessed = true;

  # vendor.scss

  if @is-vendor-styles-preprocessed and @props.ui.name != null
    style-vendor-source = 'src/app/__' + @props.ui.key + '-vendor.' + @props.css-preprocessor.extension
    @style-copies[style-vendor-source] = 'src/vendor.' + @props.css-preprocessor.extension

  # template-files
  template-files = files.templates

  if @props.css-preprocessor.key == 'none'
     template-files = _.reject template-files, (path) -> /styles\.js/.test path

  if @props.js-preprocessor.key == 'none'
     template-files = _.reject template-files, (path) -> /scripts\.js/.test path

  if @props.html-preprocessor.key == 'none'
     template-files = _.reject template-files, (path) -> /markups\.js/.test path

  # JS Preprocessor files
  resolve-paths = (template) ->
    (files-object, file) ->
      src = file
      dest = file
      if template
        basename = path.basename file
        src = file.replace basename, '_' + basename

      if src.match /\.js$/
        preprocessor-file = @source-root! + '/' + src.replace /\.js$/, '.' + @props.js-preprocessor.src-extension

        if fs.exists-sync preprocessor-file
          src = src.replace /\.js$/, '.' + @props.js-preprocessor.src-extension
          dest = dest.replace /\.js$/, '.' + @props.js-preprocessor.extension

      files-object[src] = dest

      files-object

  @src-templates = template-files.reduce (resolve-paths true .bind @), {}
  @src-templates <<< file-templates

  # static-files
  @static-files = files.static-files.reduce (resolve-paths false .bind @), {}

  # lint-conf
  @lint-conf-copies = []
  if @props.js-preprocessor.key == 'coffee'
    @lint-conf-copies.push 'coffeelint.json'

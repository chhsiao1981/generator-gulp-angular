path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'

general = yeoman.generators.NamedBase.extend do
  initializing: ->
    console.log 'initializing: start'
    @_set-name!
    @_info!
    @_check-yo-rc!
    @_retrieve-options!

  _set-name: ->
    @name = @_normalize-name @name
    @basename = @_basename @_camelcase-to-lodash @name.replace '.', '/'
    @dirname = @_dirname @_camelcase-to-lodash @name.replace '.', '/'
    @section = @_lodash-to-camelcase @dirname
    @name = @appname + '.' + @name
    @section = @appname + if @section and @section != '.' then '.' + @section else ''
    @module = @_lodash-to-camelcase @basename
    @class-camel-case = @_lodash-to-upper-camelcase @basename

    console.log 'name:', @name, 'basename:', @basename, 'dirname:', @dirname, 'section:', @section, 'module:', @module, 'class-camel-case:', @class-camel-case

  _normalize-name: (name) ->
    name = @_upper-camelcase-to-camelcase @_lodash-to-camelcase name.replace '/', '.'

  _basename: (name) ->
    path.basename name

  _dirname: (name) ->
    path.dirname name

  _lodash-to-camelcase: (name) ->
    name.replace /(\-[a-z])/g, ($1) -> $1.to-upper-case!.replace '-', ''

  _lodash-to-upper-camelcase: (name) ->
    @_lodash-to-camelcase name .replace /(^[a-z])/, ($1) -> $1.to-upper-case!

  _camelcase-to-lodash: (name) ->
    name.replace /([A-Z])/g, ($1) -> '-' + $1.to-lower-case!

  _upper-camelcase-to-camelcase: (name) ->
    name.replace /(^[A-Z])/, ($1) -> $1.to-lower-case!

  _info: ->
    if not @options['skip-welcome-message']
      @log yosay (chalk.red 'Welcome!') + '\n' + \
        (chalk.yellow 'You\'re using the fantastic generator for scaffolding an application with Angular and Gulp:' + @class-name + '!')

  _check-yo-rc: ->
    cb = @async!

    if not @config.get 'props'
      @log chalk.red 'no .yo-rc! run gulp-angular:bp first!'
    else
      @props = @config.get 'props'
      cb!

  _retrieve-options: ->

  prompting: ->

  configuring: require './format'

  writing: require './write'

  end: ->
    @log yosay (chalk.green 'All Done!')

module.exports = general

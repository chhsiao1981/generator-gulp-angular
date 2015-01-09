path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'

prompts = require './prompts.json'
advanced-prompts = require './advanced-prompts.json'
options = require './options.json'
utils = require './utils.js'

bp = yeoman.generators.Base.extend do
  constructor: ->
    yeoman.generators.Base.apply @, arguments

    # Define arguments
    @argument 'appName', do
      type: String
      required: false

    # Define options
    options.for-each (option) ~> 
      @option option.name, do
        type: global[option.type]
        required: option.required
        desc: option.desc
        defaults: option.defaults

  info: ->
    if not @options['skip-welcome-message']
      @log yosay (chalk.red 'Welcome!') + '\n' + \
        (chalk.yellow 'You\'re using the fantastic generator for scaffolding an application with Angular and Gulp:BP!')

    if @options['default']
      mock-prompts = require './mock-prompts.js'
      mock-options = require './mock-options.js'
      savable-options-defaults = @_.filter mock-options.defaults, (value, name) ~> @_.find options, {name: name} .save
      @props = 
        paths: 
          src: mock-options.defaults['app-path']
          dist: mock-options.defaults['dist-path']
          e2e: mock-options.defaults['e2e-path']
          tmp: mock-options.defaults['tmp-path']
      @config.set 'props', @_.merge @props, mock-promps.defaults

      @log '__________________________\n'
      @log 'You use ' + (chalk.green '--default') + ' option:'
      @log '''\t* angular 1.3.x
\t* ngAnimate
\t* ngCookies
\t* ngTouch
\t* ngSanitize
\t* jQuery 1.x.x
\t* ngResource
\t* ngRoute
\t* bootstrap
\t* ui-bootstrap
\t* node-sass
\t* --app-path=\'src\'
\t* --dist-path=\'dist\'
\t* --e2e-path=\'e2e\'
\t* --tmp-path=\'.tmp\'
__________________________
'''

  check-yo-rc: ->
    cb = @async!

    if @config.get 'props' and not @options['default']
      @prompt [
        * type: 'confirm'
          name: 'skipConfig'
          message: 'Existing ' + chalk.green('.yo-rc') + ' configuration found, would you like to use it?'
          default: true
      ], (answers) ~>
        @skipConfig = answers.skipConfig
        cb!
    else
      cb!

  retrieve-options: ->
    if @skip-config or @options['default']
      return

    <[ app-path dist-path e2e-path tmp-path ]>.for-each (name) ~>
      if utils.is-absolute-path @options[name]
        @env.error name + ' mus be a relative path'
      @options[name] = utils.normalize-path @options[name]

    @props = 
      paths:
        src: @options['app-path']
        dist: @options['dist-path']
        e2e: @options['e2e-path']
        tmp: @options['tmp-path']

    console.log 'after retrieve-options: props:', @props

  ask-questions: ->
    if @skipConfig or @options['default']
      return

    done = @async!

    @_.find-where prompts, {name: 'bootstrapComponents'} .when = (props) -> props.ui.key == 'bootstrap'

    @_.find-where prompts, {name: 'foundationComponents'} .when = (props) -> props.ui.key == 'foundation'

    js-preprocessor-prompts = @_.find-where prompts, {name: 'jsPreprocessor'}
    js-preprocessor-prompts.default = @_.find-index js-preprocessor-prompts.choices, {value: {key: 'livescript'}}

    html-preprocessor-prompts = @_.find-where prompts, {name: 'htmlPreprocessor'}
    html-preprocessor-prompts.default = @_.find-index html-preprocessor-prompts.choices, {value: {key: 'jade'}}

    console.log 'prompts:', prompts, 'prompts.ui.choices:', (@_.find-where prompts, {name: 'ui'} .choices)

    @prompt prompts, (props) ~>
      if props.ui.key != 'bootstrap'
        props.bootstrap-components =
          name: null
          version: null
          key: null
          module: null

      if props.ui.key != 'foundation'
        props.foundation-components =
          name: null
          version: null
          key: null
          module: null

      console.log 'props:', props

      @props <<< props
      @config.set 'props', @props

      console.log '@props:', @props

      done!

  ask-advanced-questions: ->
    if @skip-config or not @options['advanced']
      return

    done = @async!

    @prompt advanced-prompts, (props) ~>
      @props.advanced-features = props.advanced-features
      @config.set 'props', @props

      done!

  # Format props to template values
  format-props: require './format'

  # Write files (copy, template)
  write-files: require './write'

  # Install dependencies
  install: ->
    @install-dependencies do
      skip-install: @options['skip-install']
      skip-message: @options['skip-message']

module.exports = bp

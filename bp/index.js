(function(){
  var path, yeoman, yosay, chalk, prompts, advancedPrompts, options, utils, bp;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  prompts = require('./prompts.json');
  advancedPrompts = require('./advanced-prompts.json');
  options = require('./options.json');
  utils = require('./utils.js');
  bp = yeoman.generators.Base.extend({
    constructor: function(){
      var this$ = this;
      yeoman.generators.Base.apply(this, arguments);
      this.argument('appName', {
        type: String,
        required: false
      });
      return options.forEach(function(option){
        return this$.option(option.name, {
          type: global[option.type],
          required: option.required,
          desc: option.desc,
          defaults: option.defaults
        });
      });
    },
    info: function(){
      var mockPrompts, mockOptions, savableOptionsDefaults, this$ = this;
      if (!this.options['skip-welcome-message']) {
        this.log(yosay(chalk.red('Welcome!') + '\n' + chalk.yellow('You\'re using the fantastic generator for scaffolding an application with Angular and Gulp:BP!')));
      }
      if (this.options['default']) {
        mockPrompts = require('./mock-prompts.js');
        mockOptions = require('./mock-options.js');
        savableOptionsDefaults = this._.filter(mockOptions.defaults, function(value, name){
          return this$._.find(options, {
            name: name
          }).save;
        });
        this.props = {
          paths: {
            src: mockOptions.defaults['app-path'],
            dist: mockOptions.defaults['dist-path'],
            e2e: mockOptions.defaults['e2e-path'],
            tmp: mockOptions.defaults['tmp-path']
          }
        };
        this.config.set('props', this._.merge(this.props, mockPromps.defaults));
        this.log('__________________________\n');
        this.log('You use ' + chalk.green('--default') + ' option:');
        return this.log('\t* angular 1.3.x\n\t* ngAnimate\n\t* ngCookies\n\t* ngTouch\n\t* ngSanitize\n\t* jQuery 1.x.x\n\t* ngResource\n\t* ngRoute\n\t* bootstrap\n\t* ui-bootstrap\n\t* node-sass\n\t* --app-path=\'src\'\n\t* --dist-path=\'dist\'\n\t* --e2e-path=\'e2e\'\n\t* --tmp-path=\'.tmp\'\n__________________________');
      }
    },
    checkYoRc: function(){
      var cb, this$ = this;
      cb = this.async();
      if (this.config.get('props') && !this.options['default']) {
        return this.prompt([{
          type: 'confirm',
          name: 'skipConfig',
          message: 'Existing ' + chalk.green('.yo-rc') + ' configuration found, would you like to use it?',
          'default': true
        }], function(answers){
          this$.skipConfig = answers.skipConfig;
          return cb();
        });
      } else {
        return cb();
      }
    },
    retrieveOptions: function(){
      var this$ = this;
      if (this.skipConfig || this.options['default']) {
        return;
      }
      ['app-path', 'dist-path', 'e2e-path', 'tmp-path'].forEach(function(name){
        if (utils.isAbsolutePath(this$.options[name])) {
          this$.env.error(name + ' mus be a relative path');
        }
        return this$.options[name] = utils.normalizePath(this$.options[name]);
      });
      this.props = {
        paths: {
          src: this.options['app-path'],
          dist: this.options['dist-path'],
          e2e: this.options['e2e-path'],
          tmp: this.options['tmp-path']
        }
      };
      return console.log('after retrieve-options: props:', this.props);
    },
    askQuestions: function(){
      var done, jsPreprocessorPrompts, htmlPreprocessorPrompts, this$ = this;
      if (this.skipConfig || this.options['default']) {
        return;
      }
      done = this.async();
      this._.findWhere(prompts, {
        name: 'bootstrapComponents'
      }).when = function(props){
        return props.ui.key === 'bootstrap';
      };
      this._.findWhere(prompts, {
        name: 'foundationComponents'
      }).when = function(props){
        return props.ui.key === 'foundation';
      };
      jsPreprocessorPrompts = this._.findWhere(prompts, {
        name: 'jsPreprocessor'
      });
      jsPreprocessorPrompts['default'] = this._.findIndex(jsPreprocessorPrompts.choices, {
        value: {
          key: 'livescript'
        }
      });
      htmlPreprocessorPrompts = this._.findWhere(prompts, {
        name: 'htmlPreprocessor'
      });
      htmlPreprocessorPrompts['default'] = this._.findIndex(htmlPreprocessorPrompts.choices, {
        value: {
          key: 'jade'
        }
      });
      console.log('prompts:', prompts, 'prompts.ui.choices:', this._.findWhere(prompts, {
        name: 'ui'
      }).choices);
      return this.prompt(prompts, function(props){
        if (props.ui.key !== 'bootstrap') {
          props.bootstrapComponents = {
            name: null,
            version: null,
            key: null,
            module: null
          };
        }
        if (props.ui.key !== 'foundation') {
          props.foundationComponents = {
            name: null,
            version: null,
            key: null,
            module: null
          };
        }
        console.log('props:', props);
        import$(this$.props, props);
        this$.config.set('props', this$.props);
        console.log('@props:', this$.props);
        return done();
      });
    },
    askAdvancedQuestions: function(){
      var done, this$ = this;
      if (this.skipConfig || !this.options['advanced']) {
        return;
      }
      done = this.async();
      return this.prompt(advancedPrompts, function(props){
        this$.props.advancedFeatures = props.advancedFeatures;
        this$.config.set('props', this$.props);
        return done();
      });
    },
    formatProps: require('./format'),
    writeFiles: require('./write'),
    install: function(){
      return this.installDependencies({
        skipInstall: this.options['skip-install'],
        skipMessage: this.options['skip-message']
      });
    }
  });
  module.exports = bp;
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
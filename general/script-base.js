(function(){
  var path, yeoman, yosay, chalk, general;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  general = yeoman.generators.NamedBase.extend({
    initializing: function(){
      console.log('initializing: start');
      this._setName();
      this._info();
      this._checkYoRc();
      return this._retrieveOptions();
    },
    _setName: function(){
      this.name = this._normalizeName(this.name);
      this.basename = this._basename(this._camelcaseToLodash(this.name.replace('.', '/')));
      this.dirname = this._dirname(this._camelcaseToLodash(this.name.replace('.', '/')));
      this.section = this._lodashToCamelcase(this.dirname);
      this.sectionPostfix = this.section;
      this.name = this.appname + '.' + this.name;
      this.section = this.appname + (this.section && this.section !== '.' ? '.' + this.section : '');
      this.module = this._lodashToCamelcase(this.basename);
      this.classCamelCase = this._lodashToUpperCamelcase(this.basename);
      return console.log('name:', this.name, 'basename:', this.basename, 'dirname:', this.dirname, 'section:', this.section, 'section-postfix:', this.sectionPotfix, 'module:', this.module, 'class-camel-case:', this.classCamelCase);
    },
    _normalizeName: function(name){
      return name = this._upperCamelcaseToCamelcase(this._lodashToCamelcase(name.replace('/', '.')));
    },
    _basename: function(name){
      return path.basename(name);
    },
    _dirname: function(name){
      return path.dirname(name);
    },
    _lodashToCamelcase: function(name){
      return name.replace(/(\-[a-z])/g, function($1){
        return $1.toUpperCase().replace('-', '');
      });
    },
    _lodashToUpperCamelcase: function(name){
      return this._lodashToCamelcase(name).replace(/(^[a-z])/, function($1){
        return $1.toUpperCase();
      });
    },
    _camelcaseToLodash: function(name){
      return name.replace(/([A-Z])/g, function($1){
        return '-' + $1.toLowerCase();
      });
    },
    _upperCamelcaseToCamelcase: function(name){
      return name.replace(/(^[A-Z])/, function($1){
        return $1.toLowerCase();
      });
    },
    _info: function(){
      if (!this.options['skip-welcome-message']) {
        return this.log(yosay(chalk.red('Welcome!') + '\n' + chalk.yellow('You\'re using the fantastic generator for scaffolding an application with Angular and Gulp:' + this.className + '!')));
      }
    },
    _checkYoRc: function(){
      var cb;
      cb = this.async();
      if (!this.config.get('props')) {
        return this.log(chalk.red('no .yo-rc! run gulp-angular:bp first!'));
      } else {
        this.props = this.config.get('props');
        return cb();
      }
    },
    _retrieveOptions: function(){},
    prompting: function(){},
    configuring: require('./format'),
    writing: function(){
      var ref$;
      if (this.sectionPostfix && this.sectionPostfix !== '.') {
        this.composeWith('gulp-angular:' + ((ref$ = this.className) === 'controller' || ref$ === 'module' ? 'module' : 'component'), {
          args: [this.sectionPostfix]
        });
      }
      return this._writing();
    },
    _writing: require('./write'),
    end: function(){
      return this.log(yosay(chalk.green('All Done!')));
    }
  });
  module.exports = general;
}).call(this);

(function(){
  var path, files, fs;
  path = require('path');
  files = require('./files.json');
  fs = require('fs');
  module.exports = function(){
    var _, ngModules, listTechs, usedTechs, techsContent, fileTemplates, appSrc, appControllerSrc, routerPartialSrc, navbarPartialSrc, navbarControllerSrc, res$, i$, ref$, len$, eachDep, styleAppSrc, styleVendorSource, templateFiles, resolvePaths;
    _ = this._;
    if (this.skipConfig) {
      this.props = this.config.get('props');
    }
    this.appName = this.appName || path.basename(process.cwd());
    this.appName = this._.camelize(this._.slugify(this._.humanize(this.appName)));
    this.computedPaths = {
      appToBower: path.relative(this.props.paths.src, '')
    };
    this.includeModernizr = true;
    this.imageMin = true;
    this.qrCode = true;
    console.log('format: advanced-features:', this.props.advancedFeatures);
    if (this.props.advancedFeatures) {
      this.includeModernizr = this.props.advancedFeatures.indexOf('modernizr') >= 0;
      this.imageMin = this.props.advancedFeatures.indexOf('imagemin') >= 0;
      this.qrCode = this.props.advancedFeatures.indexOf('qrCode') >= 0;
    }
    ngModules = this.props.angularModules.map(function(module){
      return module.module;
    });
    ngModules = _.flatten([ngModules, this.props.resource.module, this.props.router.module, this.props.ui.module, this.props.bootstrapComponents.module]);
    this.modulesDependencies = _.chain(ngModules).filter(_.isString).map(function(dependency){
      return '\'' + dependency + '\'';
    }).valueOf().join(', ');
    this.modulesDependenciesLs = this.modulesDependencies.replace(/, /g, ' ').replace(/'/g, '');
    listTechs = require('./techs.json');
    usedTechs = ['angular', 'browsersync', 'gulp', 'jasmine', 'karma', 'protractor', this.props.jQuery.name, this.props.ui.key, this.props.bootstrapComponents.key, this.props.cssPreprocessor.key, this.props.jsPreprocessor.key, this.props.htmlPreprocessor.key].filter(_.isString).filter(function(tech){
      return tech !== 'default' && tech !== 'css' && tech !== 'official' && tech !== 'none';
    });
    techsContent = _.map(usedTechs, function(value){
      return listTechs[value];
    });
    this.technologies = JSON.stringify(techsContent, null, 2).replace(/'/g, '\\\'').replace(/"/g, '\'').replace(/\n/g, '\n    ');
    this.technologiesLogoCopies = _.map(usedTechs, function(value){
      return 'src/assets/images/' + listTechs[value].logo;
    });
    fileTemplates = {};
    this.partialCopies = {};
    appSrc = 'src/app/_index.' + this.props.jsPreprocessor.srcExtension;
    fileTemplates[appSrc] = 'src/app.' + this.props.jsPreprocessor.extension;
    appControllerSrc = 'src/app/main/_main.controller.' + this.props.jsPreprocessor.srcExtension;
    fileTemplates[appControllerSrc] = 'src/app-controller.' + this.props.jsPreprocessor.extension;
    appControllerSrc = 'src/app/main/_main.controller.spec.' + this.props.jsPreprocessor.srcExtension;
    fileTemplates[appControllerSrc] = 'src/app-controller_test.' + this.props.jsPreprocessor.extension;
    routerPartialSrc = 'src/app/main/__' + this.props.ui.key + '.' + this.props.htmlPreprocessor.extension;
    if (this.props.router.module) {
      this.partialCopies[routerPartialSrc] = 'src/app.' + this.props.htmlPreprocessor.extension;
    }
    if (this.props.router.module === 'ngRoute') {
      this.routerHtml = '<div ng-view></div>';
      this.routerJade = 'div(ng-view)';
      this.routerJs = this.read('src/app/__ngroute.' + this.props.jsPreprocessor.extension, 'utf8').replace('MainCtrl', 'AppCtrl').replace('app/main/main.html', 'app.html');
    } else if (this.props.router.module === 'ui.router') {
      this.routerHtml = '<div ui-view></div>';
      this.routerJade = 'div(ui-view)';
      this.routerJs = this.read('src/app/__uirouter.' + this.props.jsPreprocessor.extension, 'utf8').replace('MainCtrl', 'AppCtrl').replace('app/main/main.html', 'app.html');
    } else {
      this.routerHtml = this.read(routerPartialSrc, 'utf8').replace('components/navbar/navbar.html', 'navbar.html');
      this.routerHtml = this.routerHtml.replace(/^<div class="container">/, '<div class="container" ng-controller="AppCtrl">');
      this.routerHtml = this.routerHtml.replace(/\n/g, '\n    ');
      this.routerJade = this.read(routerPartialSrc, 'utf8').replace('components/navbar/navbar.html', 'navbar.html');
      this.routerJade = this.routerJade.replace(/^div.container/, 'div.container(ng-controller="AppCtrl")');
      this.routerJade = this.routerJade.replace(/\n/g, '\n    ');
      this.routerJs = '';
    }
    navbarPartialSrc = 'src/components/navbar/__' + this.props.ui.key + '-navbar.' + this.props.htmlPreprocessor.extension;
    this.partialCopies[navbarPartialSrc] = 'src/navbar.' + this.props.htmlPreprocessor.extension;
    navbarControllerSrc = 'src/components/navbar/_navbar.controller.' + this.props.jsPreprocessor.srcExtension;
    fileTemplates[navbarControllerSrc] = 'src/navbar-controller.' + this.props.jsPreprocessor.extension;
    this.injectTaskDeps = ['partials'];
    if (this.props.cssPreprocessor.key !== 'none') {
      this.injectTaskDeps.push("'styles'");
    }
    if (this.props.jsPreprocessor.key !== 'none') {
      if (this.props.jsPreprocessor.extension === 'js') {
        this.injectTaskDeps.push("'browserify'");
      } else {
        this.injectTaskDeps.push("'scripts'");
      }
    }
    res$ = [];
    for (i$ = 0, len$ = (ref$ = this.injectTaskDeps).length; i$ < len$; ++i$) {
      eachDep = ref$[i$];
      res$.push(eachDep.replace(/\'/g, ''));
    }
    this.injectTaskDepsLs = res$;
    this.wiredepExclusions = [];
    if (this.props.ui.key === 'bootstrap') {
      if (this.props.bootstrapComponents.key !== 'official') {
        if (this.props.cssPreprocessor.extension === 'scss') {
          this.wiredepExclusions.push('/bootstrap-sass-official/');
        } else {
          this.wiredepExclusions.push('/bootstrap\\.js/');
        }
      }
      if (this.props.cssPreprocessor.key !== 'none') {
        this.wiredepExclusions.push('/bootstrap\\.css/');
      }
    } else if (this.props.ui.key === 'foundation') {
      if (this.props.foundationComponents.key !== 'official') {
        this.wiredepExclusions.push('/foundation\\.js/');
      }
      if (this.props.cssPreprocessor.key !== 'none') {
        this.wiredepExclusions.push('/foundation\\.css/');
      }
    }
    if (this.props.cssPreprocessor.key !== 'none') {
      this.wiredepExclusions.push('/bootstrap\\.css/');
      this.wiredepExclusions.push('/foundation\\.css/');
    }
    if (this.props.ui.key.indexOf('bootstrap' !== -1) && this.props.cssPreprocessor.extension !== 'scss') {
      this.props.ui.name = 'bootstrap';
    }
    console.log('after format choice ui framework: props.ui:', this.props.ui);
    this.styleCopies = {};
    styleAppSrc = 'src/app/__' + this.props.ui.key + '-index.' + this.props.cssPreprocessor.extension;
    this.styleCopies[styleAppSrc] = 'src/index.' + this.props.cssPreprocessor.extension;
    this.isVendorStylesPreprocessed = false;
    if (this.props.cssPreprocessor.extension === 'scss') {
      if (this.props.ui.key === 'bootstrap' || this.props.ui.key === 'foundation') {
        this.isVendorStylesPreprocessed = true;
      }
    } else if (this.props.cssPreprocessor.extension === 'less') {
      if (this.props.ui.key === 'bootstrap') {
        this.isVendorStylesPreprocessed = true;
      }
    }
    if (this.isVendorStylesPreprocessed && this.props.ui.name !== null) {
      styleVendorSource = 'src/app/__' + this.props.ui.key + '-vendor.' + this.props.cssPreprocessor.extension;
      this.styleCopies[styleVendorSource] = 'src/vendor.' + this.props.cssPreprocessor.extension;
    }
    templateFiles = files.templates;
    if (this.props.cssPreprocessor.key === 'none') {
      templateFiles = _.reject(templateFiles, function(path){
        return /styles\.js/.test(path);
      });
    }
    if (this.props.jsPreprocessor.key === 'none') {
      templateFiles = _.reject(templateFiles, function(path){
        return /scripts\.js/.test(path);
      });
    }
    if (this.props.htmlPreprocessor.key === 'none') {
      templateFiles = _.reject(templateFiles, function(path){
        return /markups\.js/.test(path);
      });
    }
    resolvePaths = function(template){
      return function(filesObject, file){
        var src, dest, basename, preprocessorFile;
        src = file;
        dest = file;
        if (template) {
          basename = path.basename(file);
          src = file.replace(basename, '_' + basename);
        }
        if (src.match(/\.js$/)) {
          preprocessorFile = this.sourceRoot() + '/' + src.replace(/\.js$/, '.' + this.props.jsPreprocessor.srcExtension);
          if (fs.existsSync(preprocessorFile)) {
            src = src.replace(/\.js$/, '.' + this.props.jsPreprocessor.srcExtension);
            dest = dest.replace(/\.js$/, '.' + this.props.jsPreprocessor.extension);
          }
        }
        filesObject[src] = dest;
        return filesObject;
      };
    };
    this.srcTemplates = templateFiles.reduce(resolvePaths(true).bind(this), {});
    import$(this.srcTemplates, fileTemplates);
    this.staticFiles = files.staticFiles.reduce(resolvePaths(false).bind(this), {});
    this.lintConfCopies = [];
    if (this.props.jsPreprocessor.key === 'coffee') {
      return this.lintConfCopies.push('coffeelint.json');
    }
  };
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);

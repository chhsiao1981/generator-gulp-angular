(function(){
  var path, yeoman, yosay, chalk, general, files, directive;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  general = require('../general/script-base');
  files = require('./files');
  console.log('general:', general);
  directive = general.extend({
    constructor: function(){
      general.apply(this, arguments);
      this.className = 'directive';
      console.log('to setup src-files');
      this.srcFiles = files.srcFiles;
      return console.log('after setup src-files');
    },
    initializing: function(){
      return directive.__super__.initializing.call(this);
    },
    prompting: function(){
      return directive.__super__.prompting.call(this);
    },
    configuring: function(){
      return directive.__super__.configuring.call(this);
    },
    writing: function(){
      return directive.__super__.writing.call(this);
    },
    end: function(){
      return directive.__super__.end.call(this);
    }
  });
  module.exports = directive;
}).call(this);

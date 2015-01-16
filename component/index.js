(function(){
  var path, yeoman, yosay, chalk, general, files, component;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  general = require('../general/script-base');
  files = require('./files');
  console.log('general:', general);
  component = general.extend({
    constructor: function(){
      general.apply(this, arguments);
      this.className = 'component';
      console.log('to setup src-files');
      this.srcFiles = files.srcFiles;
      return console.log('after setup src-files');
    },
    initializing: function(){
      return component.__super__.initializing.call(this);
    },
    prompting: function(){
      return component.__super__.prompting.call(this);
    },
    configuring: function(){
      return component.__super__.configuring.call(this);
    },
    writing: function(){
      return component.__super__.writing.call(this);
    },
    end: function(){
      return component.__super__.end.call(this);
    }
  });
  module.exports = component;
}).call(this);

(function(){
  var path, yeoman, yosay, chalk, general, files, theModule;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  general = require('../general/script-base');
  files = require('./files');
  console.log('general:', general);
  theModule = general.extend({
    constructor: function(){
      general.apply(this, arguments);
      this.className = 'module';
      console.log('to setup src-files');
      this.srcFiles = files.srcFiles;
      return console.log('after setup src-files');
    },
    initializing: function(){
      return theModule.__super__.initializing.call(this);
    },
    prompting: function(){
      return theModule.__super__.prompting.call(this);
    },
    configuring: function(){
      return theModule.__super__.configuring.call(this);
    },
    writing: function(){
      return theModule.__super__.writing.call(this);
    },
    end: function(){
      return theModule.__super__.end.call(this);
    }
  });
  module.exports = theModule;
}).call(this);

(function(){
  var path, yeoman, yosay, chalk, general, files, value;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  general = require('../general/script-base');
  files = require('./files');
  console.log('general:', general);
  value = general.extend({
    constructor: function(){
      general.apply(this, arguments);
      this.className = 'value';
      console.log('to setup src-files');
      this.srcFiles = files.srcFiles;
      return console.log('after setup src-files');
    },
    initializing: function(){
      return value.__super__.initializing.call(this);
    },
    prompting: function(){
      return value.__super__.prompting.call(this);
    },
    configuring: function(){
      return value.__super__.configuring.call(this);
    },
    writing: function(){
      return value.__super__.writing.call(this);
    },
    end: function(){
      return value.__super__.end.call(this);
    }
  });
  module.exports = value;
}).call(this);

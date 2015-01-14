(function(){
  var path, yeoman, yosay, chalk, general, files, provider;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  general = require('../general/script-base');
  files = require('./files');
  console.log('general:', general);
  provider = general.extend({
    constructor: function(){
      general.apply(this, arguments);
      this.className = 'provider';
      console.log('to setup src-files');
      this.srcFiles = files.srcFiles;
      return console.log('after setup src-files');
    },
    initializing: function(){
      return provider.__super__.initializing.call(this);
    },
    prompting: function(){
      return provider.__super__.prompting.call(this);
    },
    configuring: function(){
      return provider.__super__.configuring.call(this);
    },
    writing: function(){
      return provider.__super__.writing.call(this);
    },
    end: function(){
      return provider.__super__.end.call(this);
    }
  });
  module.exports = provider;
}).call(this);

(function(){
  var path, yeoman, yosay, chalk, general, files, factory;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  general = require('../general/script-base');
  files = require('./files');
  console.log('general:', general);
  factory = general.extend({
    constructor: function(){
      general.apply(this, arguments);
      this.className = 'factory';
      console.log('to setup src-files');
      this.srcFiles = files.srcFiles;
      return console.log('after setup src-files');
    },
    initializing: function(){
      return factory.__super__.initializing.call(this);
    },
    prompting: function(){
      return factory.__super__.prompting.call(this);
    },
    configuring: function(){
      return factory.__super__.configuring.call(this);
    },
    writing: function(){
      return factory.__super__.writing.call(this);
    },
    end: function(){
      return factory.__super__.end.call(this);
    }
  });
  module.exports = factory;
}).call(this);

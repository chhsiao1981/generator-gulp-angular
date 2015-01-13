(function(){
  var path, yeoman, yosay, chalk, general, files, service;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  general = require('../general/script-base');
  files = require('./files');
  console.log('general:', general);
  service = general.extend({
    constructor: function(){
      general.apply(this, arguments);
      this.className = 'service';
      console.log('to setup src-files');
      this.srcFiles = files.srcFiles;
      return console.log('after setup src-files');
    },
    initializing: function(){
      return service.__super__.initializing.call(this);
    },
    prompting: function(){
      return service.__super__.prompting.call(this);
    },
    configuring: function(){
      return service.__super__.configuring.call(this);
    },
    writing: function(){
      return service.__super__.writing.call(this);
    },
    end: function(){
      return service.__super__.end.call(this);
    }
  });
  module.exports = service;
}).call(this);

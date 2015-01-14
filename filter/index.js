(function(){
  var path, yeoman, yosay, chalk, general, files, filter;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  general = require('../general/script-base');
  files = require('./files');
  console.log('general:', general);
  filter = general.extend({
    constructor: function(){
      general.apply(this, arguments);
      this.className = 'filter';
      console.log('to setup src-files');
      this.srcFiles = files.srcFiles;
      return console.log('after setup src-files');
    },
    initializing: function(){
      return filter.__super__.initializing.call(this);
    },
    prompting: function(){
      return filter.__super__.prompting.call(this);
    },
    configuring: function(){
      return filter.__super__.configuring.call(this);
    },
    writing: function(){
      return filter.__super__.writing.call(this);
    },
    end: function(){
      return filter.__super__.end.call(this);
    }
  });
  module.exports = filter;
}).call(this);

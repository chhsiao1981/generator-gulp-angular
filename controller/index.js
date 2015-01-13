(function(){
  var path, yeoman, yosay, chalk, general, files, controller;
  path = require('path');
  yeoman = require('yeoman-generator');
  yosay = require('yosay');
  chalk = require('chalk');
  general = require('../general/script-base');
  files = require('./files');
  console.log('general:', general);
  controller = general.extend({
    constructor: function(){
      general.apply(this, arguments);
      this.className = 'controller';
      console.log('to setup src-files');
      this.srcFiles = files.srcFiles;
      console.log('after setup src-files');
      if (this.name.substr(-5).toLowerCase() === '-ctrl') {
        return this.name = this.name.slice(0, -5);
      } else if (this.name.substr(-4).toLowerCase() === 'ctrl') {
        return this.name = this.name.slice(0, -4);
      }
    },
    initializing: function(){
      return controller.__super__.initializing.call(this);
    },
    prompting: function(){
      return controller.__super__.prompting.call(this);
    },
    configuring: function(){
      return controller.__super__.configuring.call(this);
    },
    writing: function(){
      return controller.__super__.writing.call(this);
    },
    end: function(){
      return controller.__super__.end.call(this);
    }
  });
  module.exports = controller;
}).call(this);

path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'
general = require '../general/script-base'
files = require './files'

console.log 'general:', general

controller = general.extend do
  constructor: ->
    general.apply @, arguments

    @class-name = 'controller'
    console.log 'to setup src-files'
    @src-files = files.src-files
    console.log 'after setup src-files'
    if @name.substr -5 .to-lower-case! == '-ctrl'
      @name = @name.slice 0, -5
    else if @name.substr -4 .to-lower-case! == 'ctrl'
      @name = @name.slice 0, -4

  initializing: ->
    controller.__super__.initializing.call @

  prompting: ->
    controller.__super__.prompting.call @

  configuring: ->
    controller.__super__.configuring.call @

  writing: ->
    controller.__super__.writing.call @

  end: ->
    controller.__super__.end.call @

module.exports = controller

path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'
general = require '../general/script-base'
files = require './files'

console.log 'general:', general

the-module = general.extend do
  constructor: ->
    general.apply @, arguments

    @class-name = 'module'
    console.log 'to setup src-files'
    @src-files = files.src-files
    console.log 'after setup src-files'

  initializing: ->
    the-module.__super__.initializing.call @

  prompting: ->
    the-module.__super__.prompting.call @

  configuring: ->
    the-module.__super__.configuring.call @

  writing: ->
    the-module.__super__.writing.call @

  end: ->
    the-module.__super__.end.call @

module.exports = the-module

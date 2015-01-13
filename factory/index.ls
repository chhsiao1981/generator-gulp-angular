path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'
general = require '../general/script-base'
files = require './files'

console.log 'general:', general

factory = general.extend do
  constructor: ->
    general.apply @, arguments

    @class-name = 'factory'
    console.log 'to setup src-files'
    @src-files = files.src-files
    console.log 'after setup src-files'

  initializing: ->
    factory.__super__.initializing.call @

  prompting: ->
    factory.__super__.prompting.call @

  configuring: ->
    factory.__super__.configuring.call @

  writing: ->
    factory.__super__.writing.call @

  end: ->
    factory.__super__.end.call @

module.exports = factory

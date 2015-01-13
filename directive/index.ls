path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'
general = require '../general/script-base'
files = require './files'

console.log 'general:', general

directive = general.extend do
  constructor: ->
    general.apply @, arguments

    @class-name = 'directive'
    console.log 'to setup src-files'
    @src-files = files.src-files
    console.log 'after setup src-files'

  initializing: ->
    directive.__super__.initializing.call @

  prompting: ->
    directive.__super__.prompting.call @

  configuring: ->
    directive.__super__.configuring.call @

  writing: ->
    directive.__super__.writing.call @

  end: ->
    directive.__super__.end.call @

module.exports = directive

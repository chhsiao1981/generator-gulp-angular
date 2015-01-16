path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'
general = require '../general/script-base'
files = require './files'

console.log 'general:', general

component = general.extend do
  constructor: ->
    general.apply @, arguments

    @class-name = 'component'
    console.log 'to setup src-files'
    @src-files = files.src-files
    console.log 'after setup src-files'

  initializing: ->
    component.__super__.initializing.call @

  prompting: ->
    component.__super__.prompting.call @

  configuring: ->
    component.__super__.configuring.call @

  writing: ->
    component.__super__.writing.call @

  end: ->
    component.__super__.end.call @

module.exports = component

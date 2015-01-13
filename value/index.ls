path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'
general = require '../general/script-base'
files = require './files'

console.log 'general:', general

value = general.extend do
  constructor: ->
    general.apply @, arguments

    @class-name = 'value'
    console.log 'to setup src-files'
    @src-files = files.src-files
    console.log 'after setup src-files'

  initializing: ->
    value.__super__.initializing.call @

  prompting: ->
    value.__super__.prompting.call @

  configuring: ->
    value.__super__.configuring.call @

  writing: ->
    value.__super__.writing.call @

  end: ->
    value.__super__.end.call @

module.exports = value

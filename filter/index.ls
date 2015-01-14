path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'
general = require '../general/script-base'
files = require './files'

console.log 'general:', general

filter = general.extend do
  constructor: ->
    general.apply @, arguments

    @class-name = 'filter'
    console.log 'to setup src-files'
    @src-files = files.src-files
    console.log 'after setup src-files'

  initializing: ->
    filter.__super__.initializing.call @

  prompting: ->
    filter.__super__.prompting.call @

  configuring: ->
    filter.__super__.configuring.call @

  writing: ->
    filter.__super__.writing.call @

  end: ->
    filter.__super__.end.call @

module.exports = filter

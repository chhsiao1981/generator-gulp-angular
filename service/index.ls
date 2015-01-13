path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'
general = require '../general/script-base'
files = require './files'

console.log 'general:', general

service = general.extend do
  constructor: ->
    general.apply @, arguments

    @class-name = 'service'
    console.log 'to setup src-files'
    @src-files = files.src-files
    console.log 'after setup src-files'

  initializing: ->
    service.__super__.initializing.call @

  prompting: ->
    service.__super__.prompting.call @

  configuring: ->
    service.__super__.configuring.call @

  writing: ->
    service.__super__.writing.call @

  end: ->
    service.__super__.end.call @

module.exports = service

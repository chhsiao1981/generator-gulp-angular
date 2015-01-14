path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'
general = require '../general/script-base'
files = require './files'

console.log 'general:', general

provider = general.extend do
  constructor: ->
    general.apply @, arguments

    @class-name = 'provider'
    console.log 'to setup src-files'
    @src-files = files.src-files
    console.log 'after setup src-files'

  initializing: ->
    provider.__super__.initializing.call @

  prompting: ->
    provider.__super__.prompting.call @

  configuring: ->
    provider.__super__.configuring.call @

  writing: ->
    provider.__super__.writing.call @

  end: ->
    provider.__super__.end.call @

module.exports = provider

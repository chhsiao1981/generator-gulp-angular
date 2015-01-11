path = require 'path'
yeoman = require 'yeoman-generator'
yosay = require 'yosay'
chalk = require 'chalk'
general = require '../general/script-base'
files = require './files'

console.log 'general:', general

constant = general.extend do
  constructor: ->
    general.apply @, arguments

    @class-name = 'constant'
    console.log 'to setup src-files'
    @src-files = files.src-files
    console.log 'after setup src-files'

  initializing: ->
    constant.__super__.initializing.call @

  prompting: ->
    constant.__super__.prompting.call @

  configuring: ->
    constant.__super__.configuring.call @

  writing: ->
    constant.__super__.writing.call @

  end: ->
    constant.__super__.end.call @

module.exports = constant

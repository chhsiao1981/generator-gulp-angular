# This module gets default yo options from options.json into a hash
# to be reused in tests and other places that requires default options

options = require './options.json'

mock-options = do
  defaults: {}

options.for-each (option) ->
  mock-options.defaults[option.name] = option.defaults

module.exports = mock-options

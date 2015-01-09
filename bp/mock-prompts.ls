# This modules reorganize the data from the prompts.json in order to be easily used in the tests
#
# It allows to avoid any duplications of the prompt values and prevent tests to use different
# or outdated values compare to the real prompts values

_ = require 'lodash'

prompts = require './prompts.json'

questions = <[ angularVersion angularModules jQuery resource router ui bootstrapComponents foundationComponents cssPreprocessor jsPreprocessor htmlPreprocessors ]>

model = {}

questions.for-each (question) ->
  model[question] = do
    choices: _.find-where prompts, {name: question} .choices
    values: {}

model.angular-version.choices.for-each (choice) ->
  title = choice.name.substring 0, choice.name.index-of '.x '
  model.angular-version.values[title] = choice.value

model.angular-modules.choices.for-each (choice) ->
  model.angular-modules.values[choice.value.name] = choice.value

model.jQuery.choices.for-each (choice) ->
  title = choice.name.substring 0, choice.name.index-of ' ('
  x-index = choice.name.index-of '.x'
  if x-index > 0
    title = title.substring 0, x-index
  model.jQuery.values[title.to-lower-case!] = choice.value

model.resource.choices.for-each (choice) ->
  title = choice.value.name
  if title is void
    title = 'None'
  model.resource.values[title.to-lower-case!] = choice.value

model.router.choices.for-each (choice) ->
  title = choice.value.name
  if title is void
    title = 'None'
  model.router.values[title.to-lower-case!] = choice.value

model.ui.choices.for-each (choice) ->
  model.ui.values[choice.value.key] = choice.value

model.bootstrap-components.choices.for-each (choice) ->
  model.bootstrap-components.values[choice.value.key] = choice.value

model.foundation-components.choices.for-each (choice) ->
  model.foundation-components.values[choice.value.key] = choice.value

model.css-preprocessor.choices.for-each (choice) ->
  model.css-preprocessor.values[choice.value.key] = choice.value

model.js-preprocessor.choices.for-each (choice) ->
  model.js-preprocessor.values[choice.value.key] = choice.value

module.exports = do
  prompts: model
  defaults:
    angular-version: model.angular-version.values['1.3']
    angular-modules: _.pluck model.angular-modules.choices, 'value'
    jQuery: model.jQuery.values['jquery 2']
    resource: model.resource.values['angular-resource']
    router: model.router.values['angular-route']
    ui: model.ui.values.bootstrap
    bootstrap-components: model.bootstrap-components.values['ui-bootstrap']
    foundation-components: model.foundation-components.values.none
    css-preprocessor: model.css-preprocessor.values['node-sass']
    js-preprocessor: model.js-preprocessor.values.none
    html-preprocessors: _.filter _.pluck model.html-preprocessors.choices, 'value', (v) -> v.key == 'jade'
  libRegexp: (name, version) -> new RegExp '"' + name + '": "' + version + '"'

(function(){
  var _, prompts, questions, model;
  _ = require('lodash');
  prompts = require('./prompts.json');
  questions = ['angularVersion', 'angularModules', 'jQuery', 'resource', 'router', 'ui', 'bootstrapComponents', 'foundationComponents', 'cssPreprocessor', 'jsPreprocessor', 'htmlPreprocessors'];
  model = {};
  questions.forEach(function(question){
    return model[question] = {
      choices: _.findWhere(prompts, {
        name: question
      }).choices,
      values: {}
    };
  });
  model.angularVersion.choices.forEach(function(choice){
    var title;
    title = choice.name.substring(0, choice.name.indexOf('.x '));
    return model.angularVersion.values[title] = choice.value;
  });
  model.angularModules.choices.forEach(function(choice){
    return model.angularModules.values[choice.value.name] = choice.value;
  });
  model.jQuery.choices.forEach(function(choice){
    var title, xIndex;
    title = choice.name.substring(0, choice.name.indexOf(' ('));
    xIndex = choice.name.indexOf('.x');
    if (xIndex > 0) {
      title = title.substring(0, xIndex);
    }
    return model.jQuery.values[title.toLowerCase()] = choice.value;
  });
  model.resource.choices.forEach(function(choice){
    var title;
    title = choice.value.name;
    if (title === void 8) {
      title = 'None';
    }
    return model.resource.values[title.toLowerCase()] = choice.value;
  });
  model.router.choices.forEach(function(choice){
    var title;
    title = choice.value.name;
    if (title === void 8) {
      title = 'None';
    }
    return model.router.values[title.toLowerCase()] = choice.value;
  });
  model.ui.choices.forEach(function(choice){
    return model.ui.values[choice.value.key] = choice.value;
  });
  model.bootstrapComponents.choices.forEach(function(choice){
    return model.bootstrapComponents.values[choice.value.key] = choice.value;
  });
  model.foundationComponents.choices.forEach(function(choice){
    return model.foundationComponents.values[choice.value.key] = choice.value;
  });
  model.cssPreprocessor.choices.forEach(function(choice){
    return model.cssPreprocessor.values[choice.value.key] = choice.value;
  });
  model.jsPreprocessor.choices.forEach(function(choice){
    return model.jsPreprocessor.values[choice.value.key] = choice.value;
  });
  module.exports = {
    prompts: model,
    defaults: {
      angularVersion: model.angularVersion.values['1.3'],
      angularModules: _.pluck(model.angularModules.choices, 'value'),
      jQuery: model.jQuery.values['jquery 2'],
      resource: model.resource.values['angular-resource'],
      router: model.router.values['angular-route'],
      ui: model.ui.values.bootstrap,
      bootstrapComponents: model.bootstrapComponents.values['ui-bootstrap'],
      foundationComponents: model.foundationComponents.values.none,
      cssPreprocessor: model.cssPreprocessor.values['node-sass'],
      jsPreprocessor: model.jsPreprocessor.values.none,
      htmlPreprocessors: _.filter(_.pluck(model.htmlPreprocessors.choices, 'value', function(v){
        return v.key === 'jade';
      }))
    },
    libRegexp: function(name, version){
      return new RegExp('"' + name + '": "' + version + '"');
    }
  };
}).call(this);

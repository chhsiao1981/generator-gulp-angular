(function(){
  var options, mockOptions;
  options = require('./options.json');
  mockOptions = {
    defaults: {}
  };
  options.forEach(function(option){
    return mockOptions.defaults[option.name] = option.defaults;
  });
  module.exports = mockOptions;
}).call(this);

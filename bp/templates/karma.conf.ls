module.exports = (config) ->
  config.set do
    auto-watch: false,
    frameworks: <[ jasmine ]>
    browsers: <[ PhantomJS ]>
    plugins: [
      'karma-phantomjs-launcher'
      'karma-jasmine'
      'karma-livescript-preprocessor'
    ]
    preprocessors:
      '**/*.ls': ['livescript']

module.exports = (config) ->
  config.set {
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

    livescript-preprocessor:
      options:
        bare: true
      transform-path: (path) -> path.replace/\.js$/, '.ls'

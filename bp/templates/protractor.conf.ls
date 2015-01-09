paths = require './.yo-rc.json' ['generator-gulp-angular'].props.paths

exports.config =
  capabilities:
    browser-name: 'chrome'

  specs: [paths.e2e + '/**/*.ls']

  jasmine-node-opts:
    show-colors: true
    default-timeout-interval: 30000
# An example configuration file.
exports.config =
  # The address of a running selenium server.
  # seleniumAddress: 'http://localhost:4444/wd/hub',
  # seleniumServerJar: deprecated, this should be set on node_modules/protractor/config.json

  # Capabilities to be passed to the webdriver instance.
  capabilities:
    browser-name: 'chrome'

  # Spec patterns are relative to the current working directly when
  # protractor is called.
  specs: <[ e2e/**/*.js ]>

  # Options to be passed to Jasmine-node.
  jasmine-node-opts:
    show-colors: true
    default-timeout-interval: 30000

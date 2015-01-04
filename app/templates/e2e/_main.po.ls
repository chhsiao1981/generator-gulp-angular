# This file uses the Page Object pattern to define the main page for tests
# https://docs.google.com/presentation/d/1B6manhG0zEXkC-H-tPo2vwU06JhL8w9-XCF9oehXzAQ
MainPage = ->
<% if (props.ui.key === 'fundation') { %>
  @jumb-el = element by.css 'panel'
<% } else { %>
  @jumb-el = element by.css '.jumbotron'
<% } %>
  @h1-el = @jumb-el.element by.css 'h1'
  @img-el = @jumb-el.element by.css 'img'

  @tech-el = element by.css '.row'
  @thumbnail-els = @tech-el.all by.repeater 'awesomeThing in awesomeThings'

module.exports = new MainPage!

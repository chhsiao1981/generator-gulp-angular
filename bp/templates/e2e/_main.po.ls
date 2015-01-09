main-page = ->
<% if (props.ui.key === 'foundation') { %>
  @jumb-el = element by.css '.panel'
<% } else { %>
  @jumb-el = element by.css 'jumbotron'
<% } %>
  @h1-el = @jumb-el.element by.css 'h1'
  @img-el = @jumb-el.element by.css 'img'
  @thumbnail-els = (element by.css 'body').all by.repeater 'awesomeThing in awesomeThings'

module.exports = new main-page!

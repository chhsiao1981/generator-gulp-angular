describe 'filter: <%= name %>', (...) ->
  before-each module '<%= section %>'

  <%= module %> = {}
  before-each inject ($filter) ->
    <%= module %> := $filter '<%= module %>'

  it 'should return the input prefixed with "<%= module %> filter:"', ->
    text = 'angularjs'
    expect <%= module %> text .to-be '<%= module %> filter: ' + text

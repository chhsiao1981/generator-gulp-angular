describe 'value: <%= name  %>', (...) ->
  before-each module '<%= section %>'

  <%= module %> = {}
  before-each inject (_<%= module %>_) ->
    <%= module %> := _<%= module %>_

  it 'should be 42', ->
    expect(<%= module %>) .to-be 42

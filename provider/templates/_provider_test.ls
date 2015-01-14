describe 'provider: <%= name %>', (...) ->
  before-each module '<%= section %>'

  <%= module %> = {}
  before-each ->
    test-module = angular.module '<%= section %>Test', ->
    test-module.config (<%= module %>Provider) ->
      <%= module %> := <%= module %>Provider

    module '<%= section %>', '<%= section %>Test',

  it 'should do something', inject ->
    expect <%= module %>.$get!.some-method! .to-be 'A\'llo'
    <%= module %>.set-salutation 'test'
    expect <%= module %>.$get!.some-method! .to-be 'test'

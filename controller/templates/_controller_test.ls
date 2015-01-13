describe 'controller: <%= section %>.<%= classCamelCase %>Ctrl', (...) ->
  before-each module '<%= section %>'

  <%= classCamelCase %>Ctrl = {}
  scope = {}

  before-each inject ($controller, $root-scope) ->
    scope := $root-scope.$new!
    <%= classCamelCase %>Ctrl = $controller '<%= classCamelCase %>Ctrl', do
      $scope: scope

  it 'should attach a list of awesome things to the scope', ->
    expect scope.awesome-things.length .to-be 3

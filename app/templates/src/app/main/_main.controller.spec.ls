describe 'controllers', (...) ->
  var scope

  before-each module '<%= appName %>'

  before-each inject ($root-scope) !->
    scope := $root-scope.$new!

  it 'should define more than 5 awesome things', inject ($controller) ->
    expect scope.awesome-things .to-be-undefined!

    $controller 'MainCtrl', do
      $scope: scope

    expect (angular.is-array scope.awesome-things) .to-be-truthy!
    expect (scope.awesome-things.length > 5) .to-be-truthy!

angular.module "<%= appName %>"
  .controller "AppCtrl", ($scope) ->
    $scope.awesomeThings = <%= technologies %>
    angular.forEach $scope.awesomeThings, (awesomeThing) ->
      awesomeThing.rank = Math.random()

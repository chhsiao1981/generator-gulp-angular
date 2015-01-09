'use strict';
/*jshint esnext: true */

class AppCtrl {
  constructor ($scope) {
    $scope.awesomeThings = <%= technologies %>;
    $scope.awesomeThings.forEach(function(awesomeThing) {
      awesomeThing.rank = Math.random();
    });
  }
}

AppCtrl.$inject = ['$scope'];

export default AppCtrl;

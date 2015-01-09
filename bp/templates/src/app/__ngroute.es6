
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'app/main/main.html',
        controller: 'AppCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  })


  .config <[ $routeProvider ]> ++ ($route-provider) ->
    $route-provider
      .when '/', do
        template-url: 'app/main/main.html',
        controller: 'AppCtrl'
      .otherwise do
        redirect-to: '/'

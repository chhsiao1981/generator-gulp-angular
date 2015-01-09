
  .config <[ $stateProvider $urlRouterProvider ]> ++ ($state-provider, $url-router-provider) ->
    $state-provider
      .state 'home', do
        url: '/',
        template-url: 'app/main/main.html',
        controller: 'AppCtrl'
    $url-router-provider.otherwise '/'

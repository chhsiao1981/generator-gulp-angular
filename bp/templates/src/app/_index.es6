'use strict';
/*jshint esnext: true */

import AppCtrl from './main/main.controller';
import NavbarCtrl from '../components/navbar/navbar.controller';

angular.module('<%= appName %>', [<%= modulesDependencies %>])
  .controller('AppCtrl', AppCtrl)
  .controller('NavbarCtrl', NavbarCtrl)
  <%= routerJs %>;

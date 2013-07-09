// Generated by CoffeeScript 1.6.1
'use strict';
angular.module('plcGrader', ['plcGrader.filters', 'plcGrader.services', 'plcGrader.directives', 'ui', 'ui.bootstrap', 'mongolab', 'ngUpload']).config([
  '$routeProvider', '$locationProvider', '$dialogProvider', function($routeProvider, $locationProvider, $dialogProvider) {
    $routeProvider.when('/uploader', {
      templateUrl: 'partial/1',
      controller: UploadCtrl
    });
    $routeProvider.when('/timeLine', {
      templateUrl: 'partial/2',
      controller: TimeLineCtrl
    });
    $routeProvider.otherwise({
      redirectTo: '/uploader'
    });
    return $locationProvider.html5Mode(true);
  }
]);

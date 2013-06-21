(function() {
  'use strict';
angular.module('plcGrader', ['plcGrader.filters', 'plcGrader.services', 'plcGrader.directives']).config([
    '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
      $routeProvider.when('/wordCount', {
        templateUrl: 'partial/1',
        controller: WordCountCtrl
      });
      $routeProvider.when('/timeLine', {
        templateUrl: 'partial/2',
        controller: TimeLineCtrl
      });
      $routeProvider.otherwise({
        redirectTo: '/wordCount'
      });
      return $locationProvider.html5Mode(true);
    }
  ]);
}).call(this);
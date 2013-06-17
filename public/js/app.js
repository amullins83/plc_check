(function() {
  'use strict';
angular.module('wordCounter', ['wordCounter.filters', 'wordCounter.services', 'wordCounter.directives']).config([
    '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
      $routeProvider.when('/uploader', {
        templateUrl: 'partial/1',
        controller: WordCountCtrl
      });
      $routeProvider.when('/timeLine', {
        templateUrl: 'partial/2',
        controller: TimeLineCtrl
      });
      $routeProvider.when('/oldTable', {
        templateUrl: 'partial/3'
      });
      $routeProvider.otherwise({
        redirectTo: '/uploader'
      });
      return $locationProvider.html5Mode(true);
    }
  ]);
}).call(this);
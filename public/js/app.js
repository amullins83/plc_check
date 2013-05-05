'use strict';


// Declare app level module which depends on filters, and services
angular.module('wordCounter', ['wordCounter.filters', 'wordCounter.services', 'wordCounter.directives']).
  config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    $routeProvider.when('/wordCount', {templateUrl: 'partial/1', controller: WordCountCtrl});
    $routeProvider.when('/timeLine', {templateUrl: 'partial/2', controller: TimeLineCtrl});
    $routeProvider.otherwise({redirectTo: '/wordCount'});
    $locationProvider.html5Mode(true);
  }]);
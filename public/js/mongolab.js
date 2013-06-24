// This is a module for cloud persistance in mongolab - https://mongolab.com
angular.module('mongolab', ['ngResource']).
    factory('Assignment', function($resource) {
      var Assignment = $resource('api/assignments/:id');
      return Assignment;
    });
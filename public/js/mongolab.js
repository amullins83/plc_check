// This is a module for cloud persistance in mongolab - https://mongolab.com
angular.module('mongolab', ['ngResource']).
    factory('Assignment', function($resource) {
      var Assignment = $resource('api/assignments/:id');
      return Assignment;
    }).
    factory('Grader', function($resource) {
      var Grader = $resource('api/grade/:id', {id:"@id"},
        {'post': {method:"POST", isArray:true}});
      return Grader;
    });
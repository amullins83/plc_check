(function() {
  'use strict';  angular.module('plcGrader.filters', []).filter('interpolate', [
    'version', function(version) {
      return function(text) {
        return String(text).replace(/\%VERSION\%/mg, version);
      };
    }
  ]).filter('wordCount', function() {
    return function(text) {
      var count;

      count = String(text).split(" ").length;
      if ((text === null) || text.length === 0) {
        return 0;
      } else {
        return count;
      }
    };
  }).filter("prettyDate", function() {
    return function(date) {
      var d = new Date(date);
      return (d.getMonth()+1) + "/" + d.getDate() + "/" + d.getFullYear();
    };
  }).filter("activeURL", ["$rootScope", function(scope) {
      return function(assignment) {
        if(scope.selectedSubmission.match(/\d/))
          return assignment.postURL;
        else
          return assignment.reflectURL;
      };
    }
  ]);
}).call(this);
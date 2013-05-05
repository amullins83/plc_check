'use strict';

/* Filters */

angular.module('wordCounter.filters', []).
  filter('interpolate', ['version', function(version) {
    return function(text) {
      return String(text).replace(/\%VERSION\%/mg, version);
    }
  }]).
  filter('wordCount', function() {
	return function(text) {
		var count = String(text).split(" ").length;
		if(typeof(text) === "undefined" || text.length === 0)
			return 0;
		else
			return count;
	};
  });

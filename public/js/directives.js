'use strict';

/* Directives */


angular.module('wordCounter.directives', []).
  directive('appVersion', ['version', function(version) {
    return function(scope, elm, attrs) {
      elm.text(version);
    };
  }]).
  directive('validColor', ['minWords', 'maxWords', function(minWords, maxWords) {
	return function(scope, elm, attrs) {
		$(document).on("keyup", "textarea", function() {
			var numWords = elm.text();
			console.log("Inside validColor: numWords = " + numWords);
			var textColor = (numWords <= maxWords && numWords >= minWords) ? "#00aa00" : "#ff8888";
			elm.css({color:textColor});
		});
	}
  }]);

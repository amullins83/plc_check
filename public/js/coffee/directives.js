  'use strict';  angular.module('wordCounter.directives', []).directive('appVersion', [
    'version', function(version) {
      return function(scope, elm, attrs) {
        return elm.text(version);
      };
    }
  ]).directive('validColor', [
    'minWords', 'maxWords', function(minWords, maxWords) {
      return function(scope, elm, attrs) {
        var setColor = function() {
          var numWords, textColor;

          numWords = elm.text();
          if (numWords <= maxWords && numWords >= minWords) {
            textColor = "#00aa00";
          } else {
            textColor = "#ff8888";
          }
          return elm.css({
            color: textColor
          });
        });

        $(document).on("keyup", "textarea", setColor);
        $(document).on("ready", setColor);
      };
    }
  ]);

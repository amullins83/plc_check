(function() {
  'use strict';  angular.module('plcGrader.directives', []).directive('appVersion', [
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

          numWords = $("textarea").val().split(" ").length;
          if (numWords <= maxWords && numWords >= minWords) {
            textColor = "#00aa00";
          } else {
            textColor = "#ff8888";
          }
      elm.text(numWords);
          return elm.css({
            color: textColor
          });
        };

        $(document).on("keyup", "textarea", setColor);
        $(document).ready(setColor);
      };
    }
  ]).directive('validButton', [
    'minWords', 'maxWords', function(minWords, maxWords) {
      return function(scope, elm, attrs) {
        var setDisable = function() {
          var numWords;

          numWords = $("textarea").val().split(" ").length;
          elm.attr("disabled", numWords > maxWords || numWords < minWords);
        };

        $(document).on("keyup", "textarea", setDisable);
        $(document).ready(setDisable);
      };
    }
  ]);
}).call(this);
'use strict'

# Directives


angular.module('wordCounter.directives', []).directive('appVersion', [
	'version',
	(version)->
		(scope, elm, attrs)->
      		elm.text version
]).directive('validColor', [
	'minWords',
	'maxWords',
	(minWords, maxWords)->
		(scope, elm, attrs)->
			$(document).on "keyup", "textarea", ->
				numWords = elm.text()
				if (numWords <= maxWords && numWords >= minWords)
					textColor = "#00aa00"
				else
					textColor = "#ff8888"
				elm.css({color:textColor})
])

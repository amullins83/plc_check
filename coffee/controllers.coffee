'use strict'

# Controllers

AppCtrl = ($scope, $http)->
  $http({method: 'GET', url: '/api/name'}).success((data, status, headers, config)->
											$scope.name = data.name
  ).error (data, status, headers, config)->
    $scope.name = 'Error!'

class WordCountCtrl
	constructor: ($)->
		$(document).on "ready", ->
			$("textarea").text document.localStorage["text"]
			
		$(document).on "keyup", "textarea", ->
			document.localStorage["text"] = $("textarea").text()

	@$inject: ["jQuery"]


class TimeLineCtrl
	constructor: ->
		
	@$inject = [];

'use strict'

# Controllers

AppCtrl = ($scope, $http)->
  $http({method: 'GET', url: '/api/name'}).success((data, status, headers, config)->
											$scope.name = data.name
  ).error (data, status, headers, config)->
    $scope.name = 'Error!'

class WordCountCtrl
	constructor: ($scope)->
		$(document).on "ready", ->
			$scope.text = window.localStorage["text"]
			
		$(document).on "keyup", "textarea", ->
			window.localStorage["text"] = $("textarea").val()

	@$inject: ['$scope']


class TimeLineCtrl
	constructor: ->
		
	@$inject: [];

'use strict'

# Controllers

AppCtrl = ($scope, $http)->
  $http({method: 'GET', url: '/api/name'}).success (data, status, headers, config)->
	$scope.name = data.name
  ).error (data, status, headers, config)->
    $scope.name = 'Error!'

class WordCountCtrl
	constructor: ->
		
	@$inject: []


class TimeLineCtrl
	constructor: ->
		
	@$inject = [];

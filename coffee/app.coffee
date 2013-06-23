
	'use strict'

	# Declare app level module which depends on filters, and services

	angular.module('plcGrader', [
		'plcGrader.filters',
		'plcGrader.services',
		'plcGrader.directives',
		'mongolab'
	]).config [
			'$routeProvider',
			'$locationProvider',
			($routeProvider, $locationProvider)->
				$routeProvider.when('/uploader', {templateUrl: 'partial/1', controller: UploadCtrl})
				$routeProvider.when('/timeLine', {templateUrl: 'partial/2', controller: TimeLineCtrl})
				$routeProvider.otherwise({redirectTo: '/uploader'})
				$locationProvider.html5Mode(true)
	]

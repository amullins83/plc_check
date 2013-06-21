(->
    'use strict'

    # Controllers

    AppCtrl = ($scope, $http)->
        $http(
            method: 'GET'
            url: '/api/name'
        ).success( (data, status, headers, config)->
            $scope.name = data.name
        ).error (data, status, headers, config)->
            $scope.name = 'Error!'

    class UploadCtrl
        constructor: (@$scope, @$http)->
            @getAssignments()

        getAssignments: ->
            @$http(
                method: 'GET'
                url: 'api/assignments'
            ).success( (data, status, headers, config)->
                @$scope.assignments = data
                console.log "Assignments retrieved."
            ).error (data, status, headers, config)->
                @$scope.assignments = []
                console.log "Error retrieving assignments"


        @$inject: ['$scope', '$http']


    class TimeLineCtrl
        constructor: ->
        
        @$inject: [];

).call this
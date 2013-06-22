'use strict'

class AppCtrl

    constructor: (@$scope, @$http)->
        @getName()
        @getAssignments()
        @getSelectedAssignment()
        @getProblems()

    getName: ->
        @$http(
            method: 'GET'
            url: '/api/name'
        ).success( (data, status, headers, config)=>
            @$scope.name = data.name
        ).error (data, status, headers, config)=>
            @$scope.name = 'Error!'

    getAssignments: ->
        @$http(
            method: 'GET'
            url: 'api/assignments'
        ).success( (data, status, headers, config)=>
            @$scope.assignments = data
            console.log "Assignments retrieved."
        ).error (data, status, headers, config)=>
            @$scope.assignments = []
            console.log "Error retrieving assignments"

    getSelectedAssignment: ->
        @$scope.selectedAssignment = @$scope.assignments[0].id

    getProblems: ->
        @$scope.problems = @$scope.assignments[0].problems

    @$inject: ['$scope', '$http']


class UploadCtrl


    @$inject: ['$scope', '$http']


class TimeLineCtrl
    constructor: ->
       
    @$inject: []

Controllers = {"AppCtrl": AppCtrl, "UploadCtrl": UploadCtrl, "TimeLineCtrl":TimeLineCtrl}
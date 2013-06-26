'use strict'

class AppCtrl

    constructor: (@$scope, @$http)->
        @getName()

    getName: ->
        @$http(
            method: 'GET'
            url: '/api/name'
        ).success( (data, status, headers, config)=>
            @$scope.name = data.name
        ).error (data, status, headers, config)=>
            @$scope.name = 'Error!'

    @$inject: ['$scope', '$http']


class UploadCtrl
    constructor: (@$scope, @$http, Assignment, Grader)->
        @$scope.assignments = []
        @$scope.feedback = []
        @$scope.assignments = Assignment.query()
        @$scope.problems = []
        @$scope.$watch "selectedAssignmentId", =>
            @$scope.selectedAssignment = Assignment.get( {id: @$scope.selectedAssignmentId}, (assignment)=>
                @$scope.problems = assignment.problems
                @$scope.postURL = assignment.url
            ) if @$scope.selectedAssignmentId?
            
        @$scope.updateGrade = (content, complete)=>
            console.log "inside updateGrade"
            console.log content
            @$scope.feedback = content.feedback
            @$scope.grade    = content.grade

    @$inject: ['$scope', '$http', 'Assignment', 'Grader']


class TimeLineCtrl
    constructor: ->
       
    @$inject: []


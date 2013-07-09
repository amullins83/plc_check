'use strict'

class DialogCtrl

    constructor: (@$scope, @$http, @$dialog)->
        @$scope.opts =
            templateUrl: 'modal/signIn'
            controller:  SignInCtrl

        @$scope.openSignIn = =>
            d = @$dialog.dialog @$scope.opts
            d.open().then (result)=>
                @$scope.didSignIn = result
                console.log result

    @$inject: ['$scope', '$http', '$dialog']


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
    constructor: (@$scope, @$http, Assignment)->
        @$scope.assignments = []
        @$scope.feedback = []
        @$scope.assignments = Assignment.query()
        @$scope.problems = []
        @$scope.$watch "selectedAssignmentId", =>
            @$scope.selectedAssignment = Assignment.get( {id: @$scope.selectedAssignmentId}, (assignment)=>
                @$scope.problems = assignment.problems
                @$scope.postURL = assignment.url
            ) if @$scope.selectedAssignmentId?
        
        @$scope.$watch "selectedProblemId", =>
            if @$scope.selectedProblemId?    
                chapter = @$scope.selectedProblemId.match(/(\d+)/)[1]
                if chapter == "1" or chapter == "2"
                    @$scope.selectedChapter = "ch1_2"
                else
                    @$scope.selectedChapter = "ch" + chapter
                

        @$scope.updateGrade = (content, complete)=>
            @$scope.feedback = content.feedback
            @$scope.grade    = content.grade

    @$inject: ['$scope', '$http', 'Assignment']


class TimeLineCtrl
    constructor: (@$scope, @$http, Assignment)->
        @$scope.assignments = []
        @$scope.assignments = Assignment.query()
       
    @$inject: ['$scope', '$http', 'Assignment']

class SignInCtrl
    constructor: (@$scope, @$http, User, @dialog)->
        @$scope.user = {}
        @$scope.close = (result)=>
            @dialog.close result

    @$inject: ['$scope', '$http', 'User', 'dialog']

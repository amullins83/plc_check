// Generated by CoffeeScript 1.6.2
'use strict';
var AppCtrl, TimeLineCtrl, UploadCtrl;

AppCtrl = (function() {
  function AppCtrl($scope, $http) {
    this.$scope = $scope;
    this.$http = $http;
    this.getName();
  }

  AppCtrl.prototype.getName = function() {
    var _this = this;

    return this.$http({
      method: 'GET',
      url: '/api/name'
    }).success(function(data, status, headers, config) {
      return _this.$scope.name = data.name;
    }).error(function(data, status, headers, config) {
      return _this.$scope.name = 'Error!';
    });
  };

  AppCtrl.$inject = ['$scope', '$http'];

  return AppCtrl;

})();

UploadCtrl = (function() {
  function UploadCtrl($scope, $http, Assignment, Grader) {
    var _this = this;

    this.$scope = $scope;
    this.$http = $http;
    this.$scope.assignments = [];
    this.$scope.feedback = [];
    this.$scope.assignments = Assignment.query();
    this.$scope.problems = [];
    this.$scope.$watch("selectedAssignmentId", function() {
      if (_this.$scope.selectedAssignmentId != null) {
        return _this.$scope.selectedAssignment = Assignment.get({
          id: _this.$scope.selectedAssignmentId
        }, function(assignment) {
          _this.$scope.problems = assignment.problems;
          return _this.$scope.postURL = assignment.url;
        });
      }
    });
    this.$scope.$watch("selectedProblemId", function() {
      var chapter;

      if (_this.$scope.selectedProblemId != null) {
        chapter = _this.$scope.selectedProblemId.match(/(\d+)/)[1];
        if (chapter === "1" || chapter === "2") {
          return _this.$scope.selectedChapter = "ch1_2";
        } else {
          return _this.$scope.selectedChapter = "ch" + chapter;
        }
      }
    });
    this.$scope.updateGrade = function(content, complete) {
      console.log("inside updateGrade");
      console.log(content);
      _this.$scope.feedback = content.feedback;
      return _this.$scope.grade = content.grade;
    };
  }

  UploadCtrl.$inject = ['$scope', '$http', 'Assignment', 'Grader'];

  return UploadCtrl;

})();

TimeLineCtrl = (function() {
  function TimeLineCtrl() {}

  TimeLineCtrl.$inject = [];

  return TimeLineCtrl;

})();

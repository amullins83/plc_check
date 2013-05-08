  'use strict';
  var AppCtrl, TimeLineCtrl, WordCountCtrl;

  AppCtrl = function($scope, $http) {
    return $http({
      method: 'GET',
      url: '/api/name'
    }).success(function(data, status, headers, config) {
      return $scope.name = data.name;
    }).error(function(data, status, headers, config) {
      return $scope.name = 'Error!';
    });
  };

  WordCountCtrl = (function() {
    function WordCountCtrl($scope, $http) {
      $scope.text = window.localStorage["text"];
      $scope.submissionTypes = ["Post 1", "Post 2", "Post 3", "Reflection"];
      $(document).on("keyup", "textarea", function() {
        window.localStorage["text"] = $("textarea").val();
        if(typeof($scope.selectedSubmission) !== "undefined") {
          for(var i = 0; i < $scope.submissionTypes.length - 1; i++) {
            if($scope.selectedSubmission === $scope.submissionTypes[i]) {
              if(typeof($scope.selectedAssignment) !== "undefined") {
                if(typeof($scope.selectedAssignment.postText) !== "undefined") {
                  $scope.selectedAssignment.postText[i] = $("textarea").val();
                }
                else {
                  $scope.selectedAssignment.postText = [];
                  $scope.selectedAssignment.postText[i] = $("textarea").val();
                }
              }
            }
          }
          if($scope.selectedSubmission === $scope.submissionTypes[length - 1]) {
            if(typeof($scope.selectedAssignment) !== "undefined") {
              $scope.selectedAssignment.reflectText = $("textarea").val();
            }
          }
        }
      });

      $(document).on("click", "#go", function() {
        if(typeof($scope.selectedAssignment) !== "undefined") {
          if(typeof($scope.selectedSubmission) !== "undefined") {
            $.post("/api/moodle", $scope.selectedAssignment, function(response) {
              $("#moodleFeedback").load(response);
              $("#go").attr("disabled", false);
            });
            $("#go").attr("disabled", true);
          }
        }
      });

      $http({
        method: 'GET',
        url: '/api/assignments'
      }).success(function(data, status, headers, config) {
        return $scope.assignments = data;
      }).error(function(data, status, headers, config) {
        return $scope.asssignments = [{name: "Error", date:"Never"}];
      });
    }

    WordCountCtrl.$inject = ['$scope', '$http'];

    return WordCountCtrl;

  })();

  TimeLineCtrl = (function() {
    function TimeLineCtrl() {}

    TimeLineCtrl.$inject = [];

    return TimeLineCtrl;

  })();

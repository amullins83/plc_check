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
		
		var assignmentOption = $("#assignment option").filter(function() {
			return $(this).text() === JSON.parse(localStorage["assignment"]).name;
		});
		
		assignmentOption.prop("selected",true);
		
		$scope.selectedAssignment;
		
		
		$("#submission option").filter(function() {
			return $(this).text() === localStorage["submission"];
		}).prop("selected", true);
		
		$scope.submissionTypes = ["Post 1", "Post 2", "Post 3", "Reflection"];
	  
		$(document).on("keyup", "textarea", function() {
			window.localStorage["text"] = $("textarea").val();
			if(typeof($scope.selectedAssignmentJSON) !== "undefined")
				$scope.selectedAssignment = JSON.parse($scope.selectedAssignmentJSON);
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
			$scope.selectedAssignmentJSON = JSON.stringify($scope.selectedAssignment);
		});

		$(document).on("change", "#assignment", function(e) {
			for(var i = 0; i < $scope.assignments.length; i++) {
				if($scope.selectedAssignment.name === $scope.assignments[i].name) {
					$scope.assignments[i] = $scope.selectedAssignment;
					break;
				}
			}
			
			var $assignment = $(e.target);
			window.localStorage["assignment"] = $assignment.val();
			
			$scope.selectedAssignment = JSON.parse($assignment.val());
		
		    if($("#submission").val() !== "") {
				if($("#submission").val() === "Reflection")
					$scope.text = $scope.selectedAssignment.reflectText;
				else {
					if(typeof($scope.selectedAssignment.postText) === "undefined")
						$scope.selectedAssignment.postText = [];
					$scope.text = $scope.selectedAssignment.postText[parseInt($("#submission").val().match(/(\d+)/)) - 1];
				}
			}
			
			

		});

      $(document).on("click", "#go", function() {
        if(typeof($scope.selectedAssignment) !== "undefined") {
          if(typeof($scope.selectedSubmission) !== "undefined") {
            $.ajax("/api/assignments", {
				data:$scope.selectedAssignment,
				success:function(response) {
              				$("#assignmentFeedback").load(response);
              			},
				type:"PUT"
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

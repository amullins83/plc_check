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

    setTimeout(function() {
      console.log("Ready!");
		  var assignmentOption = $("#assignment option").filter(function() {
        if(typeof(window.localStorage["assignment"]) === "undefined") {
          console.log("I couldn't find the assignment local store");
          return false;
        }
        console.log("The local assignment is: " + window.localStorage["assignment"]);
        console.log("The option I'm looking at is: " + $(this).text());
			 return $(this).text() === JSON.parse(window.localStorage["assignment"]).name;
		  });
		
      console.log("I found " + assignmentOption.length + " matching assignments");
      if(assignmentOption.length > 0) {
        console.log("I'm changing the value of the assignment select to " + assignmentOption.val());
        $("#assignment").val(assignmentOption.val());
        console.log("done!");
        console.log("I'm changing the selectedAssignment in scope to " + JSON.parse(window.localStorage["assignment"]));
        $scope.selectedAssignment = JSON.parse(window.localStorage["assignment"]);
        console.log("done!");
      }
		
      var $chosenSubmission = $("#submission option").filter(function() {
        console.log("localStorage['submission'] = " + window.localStorage["submission"]);
        console.log("This option = " + $(this).text());
			 return $(this).text() === window.localStorage["submission"];
		  });
		
      console.log("I found " + $chosenSubmission.length + " matches");
      console.log("Setting scope.selectedSubmission = " + $chosenSubmission.val());
      $scope.selectedSubmission = $chosenSubmission.val();
      console.log("done!");
      console.log("Setting value of the submission select to " + $scope.selectedSubmission);
      $("#submission").val($scope.selectedSubmission);
      console.log("done!");
	  }, 500);

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
      if(typeof($scope.selectedAssignment) !== "undefined") {
        for(var i = 0; i < $scope.assignments.length; i++) {
          if($scope.selectedAssignment.name === $scope.assignments[i].name) {
            $scope.assignments[i] = $scope.selectedAssignment;
            break;
				  }
        }
      }
			
			var $assignment = $(e.target);
      var $submission = $("#submission");
			window.localStorage["assignment"] = $assignment.val();
			
			$scope.selectedAssignment = JSON.parse($assignment.val());
		  $scope.selectedSubmission = $submission.val();

		  if(typeof($scope.selectedSubmission) !== "undefined" && $scope.selectedSubmission !== "") {
		  	if($scope.selectedSubmission === "Reflection")
			 		$scope.text = $scope.selectedAssignment.reflectText;
        else {
					if(typeof($scope.selectedAssignment.postText) === "undefined")
            $scope.selectedAssignment.postText = [];
          $scope.text = $scope.selectedAssignment.postText[parseInt($scope.selectedSubmission.match(/(\d+)/)) - 1];
        }
        $("textarea").val($scope.text);
        $("textarea").keyup().change();  
      }
		
      
		});

    $(document).on("change", "#submission", function(e) {
      var $submission = $(e.target);
      var $assignment = $("#assignment");
      window.localStorage["submission"] = $submission.val();

      $scope.selectedAssignment = JSON.parse($assignment.val());
      $scope.selectedSubmission = $submission.val();

      if(typeof($scope.selectedAssignment) !== "undefined") {
          if($scope.selectedSubmission === "Reflection")
            $scope.text = $scope.selectedAssignment.reflectText;
          else {
           if(typeof($scope.selectedAssignment.postText) === "undefined")
              $scope.selectedAssignment.postText = [];
           $scope.text = $scope.selectedAssignment.postText[parseInt($scope.selectedSubmission.match(/(\d+)/)) - 1];
          }

        $("textarea").val($scope.text);
        $("textarea").keyup().change();
      }
    });

      $(document).on("click", "#go", function() {
        if(typeof($scope.selectedAssignment) !== "undefined") {
          if(typeof($scope.selectedSubmission) !== "undefined") {
            $.ajax("/api/assignments", {
				data:{findObject:{name:$scope.selectedAssignment.name}, updateObject:$scope.selectedAssignment},
				success:function(response) {
              				$scope.feedback = "Successfully saved " + response.name;
              			},
        error:function(response) {
                      $scope.feedback = "Error: " + response.message;
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
        $scope.assignments = [];
        for(var i = 0; i < data.length; i++) {
          $scope.assignments.push(data[i]);
          delete $scope.assignments[i]._id;
          delete $scope.assignments[i].__v;
        }
      }).error(function(data, status, headers, config) {
        $scope.asssignments = [{name: "Error", date:"Never"}];
      });
    }

    WordCountCtrl.$inject = ['$scope', '$http'];

    return WordCountCtrl;

  })();

  TimeLineCtrl = (function() {
    function TimeLineCtrl($scope, $http) {
      $http({
        method: 'GET',
        url: '/api/assignments'
      }).success(function(data, status, headers, config) {
        $scope.assignments = [];
        for(var i = 0; i < data.length; i++) {
          $scope.assignments.push(data[i]);
          delete $scope.assignments[i]._id;
          delete $scope.assignments[i].__v;
        }
      }).error(function(data, status, headers, config) {
        $scope.asssignments = [{name: "Error", date:"Never"}];
      });
    }

    TimeLineCtrl.$inject = ['$scope', '$http'];

    return TimeLineCtrl;

  })();

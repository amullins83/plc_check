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
		  var assignmentOption = $("#assignment option").filter(function() {
        if(typeof(window.localStorage["assignment"]) === "undefined" || window.localStorage["assignment"] === "") {

          return false;
        }
			 return $(this).text() === JSON.parse(window.localStorage["assignment"]).name;
		  });
		
      if(assignmentOption.length > 0) {
        $("#assignment").val(assignmentOption.val());
        $scope.selectedAssignment = JSON.parse(window.localStorage["assignment"]);
      }
		
      var $chosenSubmission = $("#submission option").filter(function() {
			 return $(this).text() === window.localStorage["submission"];
		  });
		
		$scope.selectedSubmission = $chosenSubmission.val();
      $("#submission").val($scope.selectedSubmission);
	  }, 500);

		$scope.$watch("text", function() {
			window.localStorage["text"] = $scope.text;
			if(typeof($scope.selectedSubmission) !== "undefined") {
				for(var i = 0; i < $scope.submissionTypes.length - 1; i++) {
					if($scope.selectedSubmission === $scope.submissionTypes[i]) {
						if(typeof($scope.selectedAssignment) !== "undefined") {
							if(typeof($scope.selectedAssignment.postText) === "undefined") {
                  				$scope.selectedAssignment.postText = [];
                			}
                  			$scope.selectedAssignment.postText[i] = $scope.text;
							window.localStorage["assignment"] = JSON.stringify($scope.selectedAssignment);
              			}
            		}
          		}
				if($scope.selectedSubmission === $scope.submissionTypes[length - 1]) {
					if(typeof($scope.selectedAssignment) !== "undefined") {
						$scope.selectedAssignment.reflectText = $scope.text;
						window.localStorage["assignment"] = JSON.stringify($scope.selectedAssignment);
					}
				}
			}
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
			
		var $assignment = $("#assignment");
		var $submission = $("#submission");
		window.localStorage["assignment"] = $assignment.val();	
		$scope.selectedAssignment = JSON.parse($assignment.val());
		$scope.selectedSubmission = $submission.val();

		if(typeof($scope.selectedSubmission) !== "undefined" && $scope.selectedSubmission !== "")
		{
		  	if($scope.selectedSubmission === "Reflection")
			 	$scope.text = $scope.selectedAssignment.reflectText;
        	else {
				if(typeof($scope.selectedAssignment.postText) === "undefined")
            		$scope.selectedAssignment.postText = [];
          			$scope.text = $scope.selectedAssignment.postText[parseInt($scope.selectedSubmission.match(/(\d+)/)) - 1];
        }  
      }
		window.localStorage["text"] = $scope.text;
		$("textarea").val($scope.text);
	});

    $(document).on("change", "#submission", function(e) {
      var $submission = $("#submission");
      var $assignment = $("#assignment");
	  var newText = "";
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
      }
		window.localStorage["text"] = $scope.text;
		$("textarea").val($scope.text);
    });

    $(document).on("click", "#Save", function() {
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
            $("#Save").attr("disabled", true);
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

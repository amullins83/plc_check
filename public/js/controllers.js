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

    function WordCountCtrl($scope, jQuery) {
      $scope.text = document.localStorage["text"];
	  document.getElementsByClassName("tliText")[0].addEventListener("keyup", function(e) {
		document.localStorage["text"] = this.innerHTML;
	  });
    }

    WordCountCtrl.$inject = ["jQuery"];

    return WordCountCtrl;

  })();

  TimeLineCtrl = (function() {

    function TimeLineCtrl() {}

    TimeLineCtrl.$inject = [];

    return TimeLineCtrl;

  })();
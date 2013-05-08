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
    function WordCountCtrl() {
      $(document).on("ready", function() {
        return $scope.text = window.localStorage["text"];
      });
      $(document).on("keyup", "textarea", function() {
        return window.localStorage["text"] = $("textarea").val();
      });
    }

    WordCountCtrl.$inject = [];

    return WordCountCtrl;

  })();

  TimeLineCtrl = (function() {
    function TimeLineCtrl() {}

    TimeLineCtrl.$inject = [];

    return TimeLineCtrl;

  })();

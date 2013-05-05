'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('wordCounter.services', []).
  value('version', '0.1').
  value('minWords', 150).
  value('maxWords', 300);

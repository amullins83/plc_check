"use strict"


# httpJson = require('http-json-request')

# POST
#httpJson.postJSON('server', {my: jsonObject}, function(error, responseObject){
#  console.log(responseObject);
#});

# Other setup

httpJson = require 'http-json-request'
httpJson.defaultHost 'localhost'
httpJson.defaultPort 3000

# Other POST

# httpJson.postJSON({my: jsonObject}, function(error, responseObject){
#  console.log(responseObject);
#});

# PUT

#httpJson.putJSON({my: jsonObject}, function(error, responseObject){
#  console.log(responseObject);
#});

# GET

#httpJson.getJSON({my: jsonObject}, 'server2', function(error, responseObject){
#  console.log(responseObject);
#});

describe "Assignment API", ->
	describe "GET assignments", ->
		Assignment = {}
		realAssignments = []

		it "can wait until Jasmine gets my model directly", (done)->
			models.ready ->
				Assignment = models.Assignment
				Assignment.find (err, as)->
					realAssignments = as
				expect(realAssignments.length).not.toBe 0
				done()

		it "returns a full JSON listing of all assignments", (done)->
			httpJson.getJSON "/api/assignments", (error, responseObject)->
				assignments = JSON.parse responseObject
				expect(assignments.length).toEqual realAssignments.length
				done()
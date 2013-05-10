"use strict"
process.env.test = true

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

describe "Moodle API", ->
	Moodle = require "../../models/moodle"
	
	describe "POST an assignment", ->
		
		it "returns a happy message when successful", (done)->
			httpJson.postJSON
				name: "testPost"
				postText: ["This is the test post", "this is another", "last time, promise"]
				reflectText: "A reflection of sorts"
				postURL: "localhost:8000/api/post"
				reflectURL: "localhost:8000/api/reflect"
			, (error, responseObject)->
				if error?
					expect(error.message).toBeDefined()
				else
					expect(responseObject.message).toMatch /succesful/i
				done()

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
	Assignment = {}
	realAssignments = []
	models = require "../../models"
	db = models.db
	
	finishTest = (done)->
		Assignment = models.Assignment
		Assignment.find (err, assignments)->
			realAssignments = assignments
			expect(realAssignments.length).not.toBe 0
			done()
	
	describe "GET assignments", ->

		it "can wait until Jasmine gets my model directly", (done)->
			if db.readyState == 1
				finishTest(done)
			else
				db.once "open", ->
					finishTest(done)

		it "returns a full JSON listing of all assignments", (done)->
			httpJson.getJSON "/api/assignments", (error, assignments)->
				expect(assignments.length).toEqual realAssignments.length
				done()
				
		it "returns entries that match an input name", (done)->
			httpJson.getJSON "/api/assignments?name=Week+12", (error, assignments)->
				expect(assignments.length).toEqual 1
				done()
				
		it "returns an empty array if nothing matches", (done)->
			httpJson.getJSON "/api/assignments?name=Week+1", (error, assignments)->
				expect(assignments.length).toEqual 0
				done()
				
	newAssignment = {name: "NewStuff", postURL: "crazyStuff"}
	
	describe "POST new assignment", ->
		it "returns the new Assignment object", (done)->
			httpJson.postJSON "/api/assignments", newAssignment, (error, assignment)->
				expect(assignment.name).toEqual(newAssignment.name)
				done()
		
		it "actually saves the new object to the database", (done)->
			httpJson.getJSON "/api/assignments?name=#{escape newAssignment.name}", (error, assignments)->
				expect(assignments.length).not.toBe 0
				done()
	
	describe "PUT existing assignment", ->
		it "returns the updated object", (done)->
			putObject = 
				findObject: newAssignment
				updateObject: {name: "UpdatedStuff"}
			httpJson.putJSON "/api/assignments", putObject, (error, assignment)->
				expect(assignment.name).toEqual("UpdatedStuff")
				done()
		
		it "actually saves the updated object in the database", (done)->
			httpJson.getJSON "/api/assignments?name=UpdatedStuff", (error, assignments)->
				expect(assignments.length).not.toBe 0
				done()

	describe "DELETE existing assignment", ->
		it "returns the old object", (done)->
			httpJson.deleteJSON "/api/assignments", {name: "UpdatedStuff"}, (error, assignments)->
				expect(assignments.length).not.toBe 0
				done()
				
		it "actually removes the object from the database", (done)->
			httpJson.getJSON "/api/assignments?name=UpdatedStuff", (error, assignments)->
				expect(assignments.length).toBe 0
				done()
"use strict"

describe "Assignment", ->
	assignment1 = null
	Assignment = null

	newAssignment =
		name: "testAssignment"
		postURL:"stuff"
		reflectURL:"other"
		postText: ["things", "to", "consider"]
		reflectText: "it's like you're my mirror"
		date:"2013-05-07"
	

	
	models = require("../../models")
	
	finishTest = (done)->
		Assignment = models.Assignment
		Assignment.create newAssignment, (err, assignment)->
			Assignment.find {}, (err, assignments)->
				assignment1 = assignments[0]
				expect(assignment1).toBeDefined()
				done()

	it "defines assignment1", (done)->
		if models.db.readyState == 1
			finishTest(done)
		else
			models.db.once "open", ->
				finishTest(done)
				
	it "should have a name", ->
		expect(assignment1.name).toBeDefined()
	
	it "should have postText", ->
		expect(assignment1.postText.length).toEqual 3

	it "should have reflectText", ->
		expect(assignment1.reflectText).toBeDefined()
		
	it "should have a date", ->
		expect(assignment1.date).toBeDefined()
	
	it "should have a postURL", ->
		expect(assignment1.postURL).toBeDefined()
		
	it "should have a reflectURL", ->
		expect(assignment1.reflectURL).toBeDefined()
	
	it "can be saved", (done)->
		oldDate = assignment1.date
		assignment1.date = new Date()
		assignment1.save (err, a1)->
			expect(a1.date).not.toEqual oldDate
			done()

	describe "#addPost method", ->
			
		it "adds a post when assignment is empty", (done)->
			assignment1.postText = []
			assignment1.addPost "This is a post."
			assignment1.save (err, as1)->
				expect(as1.postText.length).toBe 1
				done()
				
		it "adds does not add a post when assignment is full", (done)->
			assignment1.postText = ["This is a post.", "hey", "what?"]
			assignment1.addPost "This is not a post"
			assignment1.save (err, as1)->
				expect(as1.postText.length).toBe 3
				done()
	
	describe "#addReflect method", ->
		
		it "adds a reflection when one doesn't exist", (done)->
			assignment1.reflectText = null
			assignment1.addReflect "This is my reflection."
			assignment1.save (err, as1)->
				expect(as1.reflectText).toBe("This is my reflection.")
				done()
				
		it "does not add a reflection otherwise", (done)->
			assignment1.addReflect "This won't be added because reflection already exists"
			assignment1.save (err, as1)->
				expect(as1.reflectText).toBe("This is my reflection.")
				done()
	
	describe "#eachDate class method", ->
		
		it "comprehends dates", (done)->
			dates = []
			Assignment.count (err, count)->
				Assignment.eachDate (date)->
					dates.push date
				, ->
					expect(dates.length).toBe count
					done()

	describe "#postsComplete method", ->
		
		it "returns true when there are already three posts", ->
			expect(assignment1.postsComplete()).toBe true
			
		it "returns false otherwise", ->
			oldPostText = assignment1.postText
			assignment1.postText = []
			expect(assignment1.postsComplete()).toBe false
			assignment1.postText = oldPostText
			
	describe "#done method", ->
		
		it "returns true when all posts and reflection are complete", ->
			expect(assignment1.done()).toBe true
			
		it "returns false otherwise", ->
			oldPost = assignment1.postText.pop()
			expect(assignment1.done()).toBe false
			assignment1.postText.push oldPost
			
	describe "#eachName method", ->

		it "comprehends names", (done)->
			names = []
			Assignment.count (err, count)->
				Assignment.eachName (name)->
					names.push name
				, ->
					expect(names.length).toBe count
					done()
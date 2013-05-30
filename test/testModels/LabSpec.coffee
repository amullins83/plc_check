"use strict"

process.env.test = true

describe "Lab", ->
	lab1 = null
	Lab = null

	newLab =
		name: "testLab"
		uploadURL:"stuff"
		problems: ["rung1", "rung2"]
		date:"2013-05-07"
	

	
	models = require "../../models"
	
	finishTest = (done)->
		Lab = models.Lab
		Lab.create newLab, (err, lab)->
			Lab.find {}, (err, labs)->
				lab1 = labs[0]
				expect(lab1).toBeDefined()
				done()

	it "defines lab1", (done)->
		if models.db.readyState == 1
			finishTest(done)
		else
			models.db.once "open", ->
				finishTest(done)
				
	it "should have a name", ->
		expect(lab1.name).toBeDefined()
	
	it "should have a date", ->
		expect(lab1.date).toBeDefined()
	
	it "should have an uploadURL", ->
		expect(lab1.uploadURL).toBeDefined()
	
	it "should have a problems array", ->
		expect(lab1.problems instanceof Array).toBe(true)

	it "can be saved", (done)->
		oldDate = lab1.date
		lab1.date = new Date()
		lab1.save (err, a1)->
			expect(a1.date).not.toEqual oldDate
			done()
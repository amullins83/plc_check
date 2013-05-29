( ->
	"use strict"
	
	Array.prototype.find = (findObject)->
		found = []
		for item in this
			isMatch = true
			for element, key in findObject
				unless item[key] == element
					isMatch = false
					break
			if isMatch
				found.push item
		return found
	
	Array.prototype.update = (findObject, updateObject)->
		objectsFound = this.find(findObject)
		unless objectsFound.length == 0
			objectsToUpdate = objectsFound[0]
			indexToUpdate = this.indexOf objectsToUpdate
			this[indexToUpdate] = updateObject
			return this[indexToUpdate]
		return false
	
	mongoose = require "mongoose"
	if process.env.test
		mongoose.connect "mongodb://localhost/test"
	else
		mongoose.connect "mongodb://#{process.env.MONGOLABS_USER}:#{process.env.MONGOLABS_PASS}@ds061787.mongolab.com:61787/heroku_app15454729"
	
	model = mongoose.model
	schema = mongoose.Schema
	db = exports.db = mongoose.connection
	
	
	
	exports.labObject = labObject =
		name: String
		date: Date
		uploadURL: String
		problems: Array
	
	exports.problemObject = problemObject =
		name: String
		rungs: Array
		score: Number
		lab: String
	
	exports.rungObject = rungObject =
		value: String
		problem: String
	
	exports.ready = ready = (handler)->
			db.once "open", handler
	
	
	RSLParser = exports.RSLParser = require "./RSLParserComplete.coffee"
	
	ready ->
		Lab = exports.Lab = mongoose.model "Lab", mongoose.Schema(labObject)
		Problem = exports.Problem = mongoose.model "Problem", mongoose.Schema(problemObject)
		Rung = exports.Rung = mongoose.model "Rung", mongoose.Schema(rungObject)
	
		Rung.prototype.run = (inputObject)->
			outputObject = {}
			for item in inputObject
				outputObject[item] = inputObject[item]
			instructions = this.value.split " "
			for instruction in instructions
				result = RSLParser.execute instruction, outputObject
				if result != null
				 	outputObject = result
				else
					break
			return outputObject
		"All systems go"
).call this
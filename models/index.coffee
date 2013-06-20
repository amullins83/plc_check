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
	if process.env.TEST_MODE
		mongoose.connect "mongodb://localhost/test"
	else
		mongoose.connect process.env.MONGOLAB_URI
			
	Model = mongoose.model
	Schema = mongoose.Schema
	db = exports.db = mongoose.connection
	
	
	
	exports.assignmentObject = assignmentObject =
		name: String
		date: Date
		uploadURL: String
		problems: Schema.Types.Mixed
	
	exports.ready = ready = (handler)->
			db.once "open", handler
	
	RSLParser = exports.RSLParser = require "./RSLParser"
	
	ready ->
		Assignment = exports.Assignment = mongoose.model "Assignment", mongoose.Schema(assignmentObject)
		"All systems go"
).call this
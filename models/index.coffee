"use strict"

mongoose = require "mongoose"
mongoose.connect 'mongodb://localhost/tliWin'
db = mongoose.connection


exports.assignmentObject =
		name: String
		date: Date
		postURL: String
		reflectURL: String
		postText: Array
		reflectText: String
	
exports.ready = (handler)->
		db.once "open", handler
	
exports.ready ->
	exports.Assignment = mongoose.model "Assignment", mongoose.Schema(exports.assignmentObject)
	exports.Assignment.prototype.addPost = (newPost)->
		unless this.postText.length == 3
			this.postText.push newPost
	
	exports.Assignment.prototype.addReflect = (newReflection)->
		unless this.reflectText?
			this.reflectText = newReflection
			
	exports.Assignment.eachDate = (handler, callback)->
		exports.Assignment.find (err, assignments)->
			handler(assignment.date) for assignment in assignments
			callback()
			
	exports.Assignment.prototype.postsComplete = ->
		return this.postText.length == 3
		
	exports.Assignment.prototype.done = ->
		return this.postText.length == 3 and this.reflectText?
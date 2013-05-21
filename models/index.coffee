"use strict"

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
	conditions: Array

exports.ready = ready = (handler)->
		db.once "open", handler
	
ready ->
	Lab = exports.Lab = mongoose.model "Lab", mongoose.Schema(labObject)
	Problem = exports.Problem = mongoose.model "Problem", mongoose.Schema(problemObject)
	Rung = exports.Rung = mongoose.model "Rung", mongoose.Schema(rungObject)

	Rung.prototype.run = (inputObject)->
		outputObject = {}
		for item in inputObject
			outputObject[item] = inputObject[item]
		for condition in conditions
			outputObject = condition(outputObject)
		return outputObject
"use strict"

mongoose = require "mongoose"
if process.env.test
	mongoose.connect "mongodb://localhost/test"
else
	mongoose.connect "mongodb://#{process.env.MONGOLABS_USER}:#{process.env.MONGOLABS_PASS}@ds061787.mongolab.com:61787/heroku_app15454729"

model = mongoose.model
schema = mongoose.Schema
db = exports.db = mongoose.connection


exports.labObject =
	name: String
	date: Date
	uploadURL: String
	problems: Array

exports.problemObject =
	name: String
	rungs: Array
	score: Number
	lab: String

exports.rungObject =
	value: String
	problem: String


exports.ready = (handler)->
		db.once "open", handler
	
exports.ready ->
	Lab = exports.Lab = mongoose.model "Lab", mongoose.Schema(exports.labObject)
	Problem = exports.Problem = mongoose.model "Problem", mongoose.Schema(exports.problemObject)
	Rung = exports.Rung = mongoose.model "Rung", mongoose.Schema(exports.rungObject)
	
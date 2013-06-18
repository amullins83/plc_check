(->
	"use strict"

	Submission = require "./Student/Submission"

	class Student
		constructor: (@name)->
			@firstName = @name.split(" ")[0]
			@lastName = @name.split(" ")[1]
			@labs = []
			@initializeLabs()
			@grade()

		initializeLabs: ->

		grade: ->
			
).call this
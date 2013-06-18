(->
	"use strict"
	grade = require "../../scripts/grade"


	class Submission
		constructor: (@chapter, @student)->
			if @chapter? and @student?
				@initializeSubmission()

		initializeSubmission: ->
			grade()
			@updateDB()

		updateDB: ->
			

).call this
"use strict"
fs = fs || require "fs"

class ParseLabs
	constructor: ->
		@error = false
		@lab = ""

	getRungs: (err, data)=>
			if err
				console.log err
				@error = true
			else
				console.log "I'm getting rungs"
				m = data.toString().match /SOR,\d.*EOR,\d/ig
				if m?
					for line in m
						console.log "Reading the line #{line}"
						@lab += line + "\n"
			@lab += "\n"
			@doneFiles += 1
			console.log "Number of files done is #{@doneFiles}"

	parse: (@dir)->
		@lab = ""
		@error = false
		fs.readdir @dir, (err, files)=>
			console.log "I read directory #{dir}"
			if err
				console.log err
				@error = true
				return
			else
				@numFiles = files.length
				console.log "The number of files I'm reading is #{@numFiles}"
				@doneFiles = 0
				for file in files
					console.log "I'm about to read #{file}"
					fs.readFile (@dir + "/" + file), @getRungs

exports.parser = new ParseLabs()

class ParseDirectory
	constructor: (@dir)->
		fs.readdir @dir, (err, data)=>
			console.log "I'm looking for folders"
			if err
				console.log err
				return
			else
				@parserList = []
				for file in data
					console.log "File = #{file}"
					path = @dir + "/" + file
					fs.stat path, (err, stats)->
						if stats.isDirectory()
							console.log "#{path} is a directory"
							thisParser = new ParseLabs()
							thisParser.parse path
							@parserList.push thisParser

exports.ParseDirectory = ParseDirectory
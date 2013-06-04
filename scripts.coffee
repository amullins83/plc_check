"use strict"
fs = require "fs"

filePath = (path, name)->
	return path + "/" + name

exports.rename = (path, findExpression, replaceExpression)->
	fs.readdir path, (err, data)->
		for file in data
			fileLocation = filePath path, file
			replaceVariables = replaceExpression.match /\$(\d+)/g
			interpolatedExpression = replaceExpression
			if replaceVariables? and file.match(findExpression)?
				for variable, index in file.match findExpression
					interpolatedExpression = interpolatedExpression.replace new RegExp("\\$#{index}","g"), variable
			newName = file.replace findExpression, interpolatedExpression
			newPath = filePath path, newName
			fs.renameSync fileLocation, newPath

exports.summarize = (path, keepExpression)->
	fs.readdir path, (err, data)->
		for name in data
			folderLocation = filePath(path, name)
			if fs.statSync(folderLocation).isDirectory() and name != "zips"
				folderData = fs.readdirSync folderLocation
				summary = ""
				for file in folderData
					fileLocation = filePath(folderLocation, file)
					if file.match(/.rsl$/) and fs.statSync(fileLocation).isFile()
						summary += file + "\n"
						text = fs.readFileSync(fileLocation).toString()
						matchText = text.match(keepExpression)
						if matchText?
							for line in matchText
								summary += line + "\n"
					fs.writeFileSync filePath(folderLocation, "labs.txt"), summary

diffs = exports.diffs = (string1, string2)->
	output = ""
	lines1 = string1.split "\n"
	lines2 = string2.split "\n"
	foundDiff = false
	index1 = index2 = 0
	for index1 in [0...lines1.length]
		line1 = lines1[index1]
		if index2 < lines2.length
			line2 = lines2[index2]

		unless line1 == line2 or (line1.match(/\.rsl/) and not line2.match(/\.rsl/))
			output += "Student Response <<<<\n#{line1}\nCorrect Answer >>>>\n#{line2}\n\n"
			foundDiff ||= true

		if line1.match /\.rsl/
			unless foundDiff
				output += " Good!\n\n"
			index2 += 1 until not(lines2[index2]?) or lines2[index2].match(/\.rsl/) or index2 == lines2.length - 1
			index2 += 1
			output += line1 + "\n"
			foundDiff = false
		else unless line2.match /\.rsl/
			index2 += 1

	return output

exports.compare = (path)->
	fs.readdir path, (err, data)->
		answers = fs.readFileSync(filePath(path, "Examples/labs.txt")).toString()
		for name in data
			unless name == "Examples" or name == "zips"
				folderLocation = filePath(path, name)
				if fs.statSync(folderLocation).isDirectory()
					fileLocation = filePath(folderLocation, "labs.txt")
					folderData = fs.readdirSync(folderLocation)
					foundLabs = false
					for file in folderData
						if file == "labs.txt"
							foundLabs = true
							break
					if foundLabs
						studentLabs = fs.readFileSync(filePath(folderLocation, "labs.txt")).toString()
						fs.writeFileSync(filePath(folderLocation, "diffs.txt"), diffs(studentLabs, answers))

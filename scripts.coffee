"use strict"
fs = require "fs"

exports.rename = (path, findExpression, replaceExpression)->
	fs.readdir path, (err, data)->
		for file in data
			filePath = path + "/" + file
			newName = file.replace findExpression, replaceExpression
			newPath = path + "/" + newName
			fs.renameSync filePath, newPath

filePath = (path, name)->
	return path + "/" + name

exports.summarize = (path, keepExpression)->
	fs.readdir path, (err, data)->
		for name in data
			folderLocation = filePath(path, name)
			if fs.statSync(folderLocation).isDirectory()
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

diffs = (string1, string2)->
	output = ""
	lines1 = string1.split "\n"
	lines2 = string2.split "\n"
	foundDiff = false
	for line, index in lines1
		if line.match(/.rsl/)
			unless foundDiff
				output += " Good!\n\n"
			output += line + "\n"
			foundDiff = false
		else unless line == lines2[index]
			output += "1 <<<<\n#{line}\n2 >>>>\n#{lines2[index]}\n\n"
			foundDiff ||= true
	return output

exports.compare = (path)->
	fs.readdir path, (err, data)->
		answers = fs.readFileSync(filePath(path, "Examples/labs.txt")).toString()
		for name in data
			unless name == "Examples"
				folderLocation = filePath(path, name)
				if fs.statSync(folderLocation).isDirectory()
					studentLabs = fs.readFileSync(filePath(folderLocation, "labs.txt")).toString()
					fs.writeFileSync(filePath(folderLocation, "diffs.txt"), diffs(studentLabs, answers))

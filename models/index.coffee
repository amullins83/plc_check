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
		indexToUpdate = this.indexOf objectToUpdate
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

SOR = (rungNumber)->

EOR = (rungNumber)->

END = (rungNumber)->

XIC =  (file, rank, bit, dataTable)-> 
	if dataTable[file][rank][bit]
		return dataTable
	else
		return false

XIO = (file, rank, bit, dataTable)-> 
	unless dataTable[file][rank][bit]
		return dataTable
	else
		return false

OTE =  (file, rank, bit, dataTable)->
	dataTable[file] = dataTable[file] || {}
	dataTable[file][rank] = dataTable[file][rank] || {}
	dataTable[file][rank][bit] = true
	return dataTable

OTL =  (file, rank, bit, dataTable)->
	dataTable[file] = dataTable[file] || {}
	dataTable[file][rank] = dataTable[file][rank] || {}
	dataTable[file][rank][bit] = true
	dataTable["latch"] = dataTable["latch"] || []
	if dataTable["latch"].indexOf {file: file, rank: rank, bit: bit} == -1
		dataTable["latch"].push {file: file, rank: rank, bit: bit}
	return dataTable

OTU = (file, rank, bit, dataTable)->
	dataTable[file] = dataTable[file] || {}
	dataTable[file][rank] = dataTable[file][rank] || {}
	dataTable[file][rank][bit] = false
	if dataTable["latch"]?
		removeIndex = dataTable["latch"].indexOf {file: file, rank: rank, bit: bit}
	unless removeIndex == -1
		dataTable.splice removeIndex, 1
	return dataTable

OSR = (file, rank, bit, dataTable)->
	if dataTable[file][rank][bit]
		return false
	else
		dataTable[file][rank][bit] = true
		dataTable["oneShots"] = dataTable["oneShots"] || []
		findObject = {file:file, rank:rank, bit:bit}
		foundOneShots = dataTable["oneShots"].find findObject
		if foundOneShots.length == 0
			dataTable["oneShots"].push {file: file, rank: rank, bit: bit, active: true}
		else
			dataTable["oneShots"].update findObject, {file: file, rank: rank, bit: bit, active:true}
		return dataTable

BST = (branchNumber)->

NXB = (branchNumber)->

BND = (branchNumber)->

Logical = (bitWiseFunction)->
	(sourceAfile, sourceArank, sourceBfile, sourceBrank, destFile, destRank, dataTable)->
		dataTable[destFile] = dataTable[destFile] || {}
		dataTable[destFile][destRank] = dataTable[destFile][destRank] || {}
		for i in [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
			dataTable[sourceAfile][sourceArank][i] = dataTable[sourceAfile][sourceArank][i] || 0
			dataTable[sourceBfile][sourceBrank][i] = dataTable[sourceBfile][sourceBrank][i] || 0
			dataTable[destFile][destRank][i] = bitWiseFunction dataTable[sourceAfile][sourceArank][i], dataTable[sourceBfile][sourceBrank][i]

AND = Logical (a,b)->
	a and b

OR = Logical (a,b)->
	a or b

XOR = Logical (a,b)->
	a ^ b

NOT = Logical (a,b)->
	not a

TON = (timer, preset, dataTable)->

TOF = (timer, preset, dataTable)->

RTO = (timer, preset, dataTable)->

RES = (file, rank, dataTable)->

CTU = (counter, preset, dataTable)->

CTD = (counter, preset, dataTable)->

do = (instruction, dataTable)->
	functionMap =
		"SOR,(\\d+)": SOR
		, "EOR,(\\d+)": EOR
		, "END,(\\d+)": END
		, "XIC,(\\w+):(\\d+)\\/(\\d{1,2})": XIC
		, "XIO,(\\w+):(\\d+)\\/(\\d{1,2})": XIO
		, "OTE,(\\w+):(\\d+)\\/(\\d{1,2})": OTE
		, "OTL,(\\w+):(\\d+)\\/(\\d{1,2})": OTL
		, "OTU,(\\w+):(\\d+)\\/(\\d{1,2})": OTU
		, "OSR,(\\w+):(\\d+)\\/(\\d{1,2})": OSR
		, "BST,(\\d+)": BST
		, "NXB,(\\d+)": NXB
		, "BND,(\\d+)": BND
		, "AND,(\\w+):(\\d+),(\\w+):(\\d+),(\\w+):(\\d+)": AND
		, "OR,(\\w+):(\\d+),(\\w+):(\\d+),(\\w+):(\\d+)": OR
		, "XOR,(\\w+):(\\d+),(\\w+):(\\d+),(\\w+):(\\d+)": XOR
		, "NOT,(\\w+):(\\d+),(\\w+):(\\d+)": NOT
		, "TON,T4:(\\d+),(\\d+)": TON
		, "TOF,T4:(\\d+),(\\d+)": TOF
		, "RTO,T4:(\\d+),(\\d+)": RTO
		, "RES,(\\w+):(\\d+)": RES
		, "CTU,C5:(\\d+),(\\d+)": CTU
		, "CTD,C5:(\\d+),(\\d+)": CTD
	]
	return dataTable

ready ->
	Lab = exports.Lab = mongoose.model "Lab", mongoose.Schema(labObject)
	Problem = exports.Problem = mongoose.model "Problem", mongoose.Schema(problemObject)
	Rung = exports.Rung = mongoose.model "Rung", mongoose.Schema(rungObject)

	Rung.prototype.run = (inputObject)->
		outputObject = {}
		for item in inputObject
			outputObject[item] = inputObject[item]
		instructions = value.split " "
		for instruction in instructions
			result = do(instruction, outputObject)
			if result?
			 	outputObject = result
			else
				break
		return outputObject

	Rung.prototype.
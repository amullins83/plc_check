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

SOR = (matchValues, dataTable)->
	[matchText, rungNumber] = matchValues
	dataTable.rungs = dataTable.rungs || []
	dataTable.rungs.push rungNumber
	dataTable.activeRung = rungNumber
	dataTable.rungOpen = true
	dataTable.programOpen = true
	return dataTable

ending = (lastAction, errorMessage = "EOR does not match SOR")->
	(matchValues, dataTable)->
		[matchText, rungNumber] = matchValues
		if rungNumber == dataTable.activeRung
			dataTable.rungOpen = false
			if typeof lastAction  == "Function"
				lastAction
			return dataTable
		else
			throw "EOR does not match SOR"

EOR = ending

END = ending ->
		dataTable.programOpen = false
, "END does not match SOR"

bitwiseInput = (bitwiseFunction)->
	(matchValues, dataTable)->
		[matchText, file, rank, bit] = matchValues
		if bitwiseFunction(dataTable[file][rank][bit])
			return dataTable
		else
			return false

XIC = bitwiseInput (bit)->
	return bit == true or bit == 1

XIO = bitwiseInput (bit)->
	return bit == false or bit == 0

bitwiseOutput = (set, latchAction = -> )->
	(matchValues, dataTable)->
		[matchText, file, rank, bit] = matchValues
		dataTable[file] = dataTable[file] || {}
		dataTable[file][rank] = dataTable[file][rank] || {}
		dataTable[file][rank][bit] = set
		dataTable = latchAction

OTE =  bitwiseOutput true

OTL =  bitwiseOutput true, ->
	dataTable["latch"] = dataTable["latch"] || []
	if dataTable["latch"].indexOf {file: file, rank: rank, bit: bit} == -1
		dataTable["latch"].push {file: file, rank: rank, bit: bit}
	return dataTable

OTU = bitwiseOutput false, ->
	if dataTable["latch"]?
		removeIndex = dataTable["latch"].indexOf {file: file, rank: rank, bit: bit}
	unless removeIndex == -1
		dataTable.splice removeIndex, 1
	return dataTable

OSR = (matchValues, dataTable)->
	[matchText, file, rank, bit] = matchValues
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

branchInstruction = (branchAction)->
	(matchValues, dataTable)->
		[matchText, branchNumber] = matchValues
		dataTable = branchAction

class Branch
	constructor: (@branchNumber)->
		@topLine    = true
		@bottomLine = true
		@onTopLine  = true
		@open       = true

BST = branchInstruction ->
	dataTable.branches = dataTable.branches || []
	dataTable.branches[branchNumber - 1] = new Branch branchNumber
	return dataTable

branchClosing = (closingType)->
	branchInstruction ->
		activeBranch = dataTable.branches[branchNumber - 1]
		if closingType == "NXB"
			correctLine = activeBranch.onTopLine
			thingToClose = "onTopLine"
		else
			correctLine = not activeBranch.onTopLine
			thingToClose = "open"

		if correctLine
			if activeBranch.open
				activeBranch[thingToClose] = false
				dataTable.branches[branchNumber - 1] = activeBranch
				return dataTable
			else
				throw "Encountered #{closingType} for closed branch"
		else
			throw "Unexpected #{closingType}"

NXB = branchClosing "NXB"

BND = branchClosing "BND"

Logical = (bitwiseFunction)->
	(matchValues, dataTable)->
		[matchText, sourceAfile, sourceArank, sourceBfile, sourceBrank, destFile, destRank] = matchValues
		dataTable[destFile] = dataTable[destFile] || {}
		dataTable[destFile][destRank] = dataTable[destFile][destRank] || {}
		for i in [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
			dataTable[sourceAfile][sourceArank][i] = dataTable[sourceAfile][sourceArank][i] || 0
			dataTable[sourceBfile][sourceBrank][i] = dataTable[sourceBfile][sourceBrank][i] || 0
			dataTable[destFile][destRank][i] = bitwiseFunction dataTable[sourceAfile][sourceArank][i], dataTable[sourceBfile][sourceBrank][i]
		return dataTable

AND = Logical (a,b)->
	a and b

OR = Logical (a,b)->
	a or b

XOR = Logical (a,b)->
	a ^ b

NOT = Logical (a,b)->
	not a

class CounterTimer
	constructor: (@number, @preset)->
		@acc = 0
		@en = true
		@dn = @done()

	tickUp: ->
		@acc++
		@dn = @done()

	tickDown: ->
		@acc--
		@dn = @done()

	done: ->
		@acc >= @preset

class Counter extends CounterTimer
	CU: ->
		@tickUp()
		@cu = true

	CD: ->
		@tickDown()
		@cu = true

	OV: ->

	UV: ->

class Timer extends CounterTimer
	tick: ->
		unless @done()
			@tickUp()
			@tt = true
		else
			@tt = false




counterTimerInstruction = (file, action)->
	(matchValues, dataTable)->
		[number, preset] = matchValues
		dataTable[file] = dataTable[file] || {}
		dataTable[file][number] = dataTable[file][number] || new CounterTimer(number, preset)
		unit = dataTable[file][number]
		dataTable = action(unit)

timerInstruction = (timerAction)->
	counterTimerInstruction "T4", timerAction

TON = timerInstruction (timer)->


TOF = timerInstruction (timer)->

RTO = timerInstruction (timer)->

RES = (matchValues, dataTable)->
	[matchText, file, rank] = matchValues
	dataTable[file][rank].acc = 0

counterInstruction = (counterAction)->
	counterTimerInstruction "C5", counterAction

CTU = counterInstruction (counter)->

CTD = counterInstruction (counter)->

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


execute = (instruction, dataTable)->
	for re, f of functionMap
		matchValues = instruction.match new RegExp(re) 
		if matchValues?
			dataTable = f matchValues, dataTable
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
			result = execute(instruction, outputObject)
			if result?
			 	outputObject = result
			else
				break
		return outputObject

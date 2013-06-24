(->
    "use strict"
    fs = require "fs"
    RSLParser = require "../models/RSLParser.coffee"
    Find = require "../models/find.coffee"
    DataTable = require "../models/dataTable.coffee"

    class Grader
        constructor: (@folderPath)->
            @studentFiles = Grader.filterRSL fs.readdirSync @folderPath
            @feedback = ""

        @filterRSL: (array)->
            return Find.filter array, /^(\d+)-(\d+)([a-z]?)\.rsl$/i

        initializeProblems: ->
            @problems = {}
            for file in @studentFiles
                problemName = file.replace(/\.rsl$/, "")
                @problems[problemName] =
                    submission: fs.readFileSync("#{@folderPath}/#{file}").toString()
                    tests: []
            

        run: ->
            @score = @max = 0
            for problemName, problem of @problems
                if problem.submission == ""
                    points = problem.tests.map((test)-> return test().points).reduce( (value, sum)-> sum + value)
                    @max += points
                    @feedback += "#{problemName}: Make sure to include this problem in your submission. -#{points} \n\n"
                else
                    failedAny = false
                    for test in problem.tests
                        {result:result, feedback:feedback, points:points} = test()
                        @max += points
                        if result
                            @score += points
                        else
                            @feedback += "#{problemName}: Make sure #{feedback}. -#{points} \n"
                            failedAny = true
                    if failedAny
                        @feedback += "\n"
            @grade = Math.floor @score/(@max * 1.0)*100

        addTest: (problem, description, points, testInput, testOutput)->
            @problems[problem] = @problems[problem] || {submission: "", tests:[]}

            @problems[problem].tests.push =>
                if typeof testInput == "function"
                    actualInput = testInput()
                else
                    actualInput = testInput
    
                actualOutput = RSLParser.runRoutine @problems[problem].submission, actualInput
                if Find.match testOutput, actualOutput
                    return @testReport true, "Good!", points
                else
                    debug = "\n    Expected: #{Grader.printObject testOutput}\n    Received: #{Grader.printObject actualOutput}\n"
                    return @testReport false, description, points, debug

        @printObject: (thing)->
            if typeof thing is "function"
                return "[ function ]"

            unless typeof thing is "object"
                return thing

            output = "{"
            for key, value of thing
                output += ", " unless output == "{"
                output += "#{key}: #{Grader.printObject value}"
            output += "}"

        addOrTest: (problem, description, points, inputObjectSet, outputObjectSet)->
            @problems[problem] = @problems[problem] || {submission: "", tests:[]}

            if @problems[problem].submission == ""
                @problems[problem].tests.push =>
                    return @testReport false, "to include this problem in your submission", points
            else
                @problems[problem].tests.push =>
                    pass = false
                    for testInput, index in inputObjectSet
                        testOutput = outputObjectSet[index]
                        if typeof testInput == "function"
                            actualInput = testInput()
                        else
                            actualInput = testInput
    
                        actualOutput = RSLParser.runRoutine @problems[problem].submission, actualInput
                        if Find.match testOutput, actualOutput
                            pass = true
                            break

                    if pass
                        return @testReport true, "Good!", points               
                    else
                        return @testReport false, description, points

        simpleAddOr: (problem, description, points, inputArray, initOutputArray, finalOutputArray)->
            orTestInitialTable = []
            orTestFinalTable = []

            for inputObject, index in inputArray
                orTestInitialTable.push {I: {1: inputObject}}
                if initOutputArray? and initOutputArray[index]?
                    orTestInitialTable[index].O = {2: initOutputArray[index]}
                else
                    orTestInitialTable[index].O = {2: {}}
                if finalOutputArray? and finalOutputArray[index]?
                    orTestFinalTable.push {O: {2: finalOutputArray[index]}}
                else
                    orTestFinalTable.push {O: {2: {}}}

            @addOrTest problem, description, points, orTestInitialTable, orTestFinalTable

        testReport: (result, feedback, points, debug)->
            {result:result, feedback:feedback, points:points, debug: debug}

        @keys: (obj)->
            prop for prop of obj

        @values: (obj)->
            obj[prop] for prop of obj

        @len: (obj)->
            @keys(obj).length

        @simpleDataTable: class simpleDataTable
            constructor: (inputBits, outputBits)->
                @I = {1: {}}
                for bit, value of inputBits
                    @I[1][bit] = value

                @O = {2: {}}
                for bit, value of outputBits
                    @O[2][bit] = value

        simpleAdd: (name, desc, points, inputBits, outputBitsStart, outputBitsFinish)->
            @addTest name, desc, points, {I: {1: inputBits}, O: {2: outputBitsStart}}, {O: {2: outputBitsFinish}}

        runThroughTwice: (problem, firstInput, secondInput)->
            =>
                initialDataTable = new DataTable()
                for bit, value of firstInput
                    initialDataTable.I[1][bit] = value
    
                intermediateDataTable = RSLParser.runRoutine @problems[problem].submission, initialDataTable
    
                for bit, value of secondInput
                    intermediateDataTable.I[1][bit] = value
    
                return RSLParser.runRoutine @problems[problem].submission, intermediateDataTable

        runThroughXtimes: (problem, inputArray)->
            =>
                dt = new DataTable()

                for inputObject in inputArray
                    for bit, value of inputObject
                        dt.I[1][bit] = value
                    dt = RSLParser.runRoutine @problems[problem].submission, dt

                return dt

    module.exports = Grader
).call this
(->
    "use strict"
    fs = require "fs"
    RSLParser = require "../models/RSLParser.coffee"
    Find = require "../models/RSLParser/find.coffee"
    DataTable = require "../models/dataTable.coffee"

    class Grader
        constructor: (@folderPath)->
            @studentFiles = Grader.filterRSL fs.readdirSync @folderPath
            @exampleFiles = Grader.filterRSL fs.readdirSync "#{@folderPath}/../Examples"
            @feedback = ""

        @filterRSL: (array)->
            return Find.filter array, /^(\d+)-(\d+)([a-z]?)\.rsl$/i

        initializeProblems: ->
            @problems = {}
            for file in @exampleFiles
                problemName = file.replace(/\.rsl$/, "")
                @problems[problemName] =
                    submission: fs.readFileSync("#{@folderPath}/#{file}").toString() if fs.existsSync "#{@folderPath}/#{file}"
                    tests: []
            

        run: ->
            @score = @max = 0
            for problemName, problem of @problems
                for test in problem.tests
                    {result:result, feedback:feedback, points:points} = test()
                    @max += points
                    if result
                        @score += points
                    else
                        @feedback += "#{problemName}: Make sure #{feedback}. -#{points} \n"
            @grade = Math.floor @score/(@max * 1.0)*100

        addTest: (problem, description, points, testInput, testOutput)->
            @problems[problem].tests.push =>
                actualOutput = RSLParser.runRoutine @problems[problem].submission, testInput
                if Find.match testOutput, actualOutput
                    return @testReport true, "Good!", points               
                else
                    description += "\n    Expected: #{Grader.printObject testOutput}\n    Received: #{Grader.printObject actualOutput}\n"
                    return @testReport false, description, points


        @printObject: (thing)->
            unless typeof thing is "object"
                return thing

            output = "{"
            for key, value of thing
                output += ", " unless output == "{"
                output += "#{key}: #{Grader.printObject value}"
            output += "}"

        addSimpleTest: (name, description, points, inputArray, outputArray)->
            dt_in =
                I:
                    1:{}

            if inputArray?
                for value, bit in inputArray
                    dt_in.I[1][bit] = value

            dt_out = {}
            if outputArray?
                for bit in outputArray
                    dt_out.O = dt_out.O || {2: {}}
                    dt_out.O[2][bit] = true

            @addTest name, description, points, dt_in, dt_out

        testReport: (result, feedback, points)->
            {result:result, feedback:feedback, points:points}

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
            @addTest name, desc, points, new Grader.simpleDataTable(inputBits, outputBitsStart), new Grader.simpleDataTable(inputBits, outputBitsFinish)


    module.exports = Grader
).call this
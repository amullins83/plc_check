(->
    "use strict"
    fs = require "fs"
    RSLParser = require "../models/RSLParser.coffee"
    Find = require "../models/RSLParser/find.coffee"
    DataTable = require "../models/dataTable.coffee"

    class Grader
        constructor: (@folderPath)->
            @studentFiles = fs.readdirSync @folderPath
            @exampleFiles = fs.readdirSync "#{@folderPath}/../Examples"
            @feedback = ""

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
            @grade = @score/(@max * 1.0)

        addTest: (problem, description, points, testInput, testOutput)->
            @problems[problem].tests.push =>
                if Find.match testOutput, RSLParser.runRoutine(@problems[problem].submission, testInput)
                    return @testReport true, "Good!", points               
                else
                    return @testReport false, description, points



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

    module.exports = Grader
).call this
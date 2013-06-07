(->
    "use strict"
    fs = require "fs"

    class Grader
        constructor: (@folderPath)->
            @studentFiles = fs.readdirSync @folderPath
            @exampleFiles = fs.readdirSync "#{@folderPath}/../Examples"
            @initializeProblems()
            @score = @max = 0
            @feedback = ""
            @run()

        initializeProblems: ->
            @problems = {}
            for file in @exampleFiles
                problemName = file.replace(/\.rsl$/, "")
                @problems[problemName] =
                    submission: fs.readFileSync("#{@folderPath}/#{file}").toString() if fs.existsSync "#{@folderPath}/#{file}"
                    tests: []
            

        run: ->
            for problemName, problem of @problems
                @max += problem.tests.length
                for test in problem.tests
                    if test()
                        @score += 1
                    else
                        @feedback += "#{problemName}: #{@perTestFeedback} \n"
            @grade = @score/(@max * 1.0)

        addTest: (problem, description, testFunction)->
            @problems[problem].tests.push ->
                {result:result, feedback:feedback} = testFunction(problem)

                unless result
                    @perTestFeedback = "#{description}: #{feedback}"

        testReport: (result, feedback)->
            {result:result, feedback:feedback}

        @keys: (obj)->
            prop for prop of obj

        @values: (obj)->
            obj[prop] for prop of obj

        @len: (obj)->
            @keys(obj).length

    module.exports = Grader
).call this
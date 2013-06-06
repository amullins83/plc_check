(->
    "use strict"
    fs = require "fs"

    class Grader
        constructor: (@folderPath)->
            @studentFiles = fs.readdirSync @folderPath
            @exampleFiles = fs.readdirSync @folderPath + "../Examples"
            @initializeProblems()
            @score = @max = 0
            @feedback = ""
            @run()

        initializeProblems: ->
            # must be defined in subclass
            @problems = {}

        run: ->
            for problem, testArray of @problems
                @max += testArray.length
                for test in testArray
                    if test()
                        @score += 1
                    else
                        @feedback += @perTestFeedback + "\n"
            @grade = float(@score)/float(@max)

        addTest: (problem, testFunction)->
            @problems[problem] = @problems[problem] || []
            @problems[problem].push testFunction

        # more to be added here once I get some real-world functions made

    module.exports = Grader
).call this
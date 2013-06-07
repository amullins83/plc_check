(->
    "use strict"

    RSLParser = require "../models/RSLParser.coffee"
    DataTable = require "../models/dataTable.coffee"
    fs = require "fs"
    Grader = require "./grader.coffee"
    Find = require "../models/RSLParser/find.coffee"

    class Grader_ch1_2 extends Grader
        constructor: (@folderPath)->
            super @folderPath

        addSimpleTest: (name, description, feedback, inputArray, outputArray)->
            @addTest name, description, (name)->
                dt_in = ->
                    dt = new DataTable
                    for value, bit in inputArray
                        dt.I[1][bit] = value
                    return dt

                dt_out = ->
                    dt = dt_in()
                    for bit in outputArray
                        dt.addOutput 2,bit
                    return dt

                if Find.Match RSLParser.runRoutine(@problems[name].submission, dt_in()), dt_out()
                    return @testReport true, "Good!"
                else
                    return @testReport false, feedback


        initializeProblems: ->
            super()

            @addSimpleTest "1-1a", "output O:2/0 is on when I:1/0 and I:1/1 are on", "O:2/0 not on when I:1/0 and I:1/2 on", [true, true, false], [0]
            @addSimpleTest "1-1a", "output O:2/0 is on when I:1/2 is on", "O:2/0 not on when I:1/2 on", [false, true, true], [0]
            @addSimpleTest "1-1a", "output O:2/0 is off otherwise", "O:2/0 on when it should not be", [true, false, false], []

            
    module.exports = Grader_ch1_2
).call this
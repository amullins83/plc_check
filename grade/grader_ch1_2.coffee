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
            @initializeProblems()
            @run()

        initializeProblems: ->
            super()
            @add_1_1_tests()
            @add_1_2_tests()
            @add_1_3_tests()
            @add_1_4_tests()
            @add_1_5_tests()
            @add_1_6_tests()
            @add_2_1_tests()
            @add_2_2_tests()
        
        add_1_1_tests: ->
            @add_1_1_a_tests()
            @add_1_1_b_tests()
            @add_1_1_c_tests()
            @add_1_1_d_tests()

        add_1_1_a_tests: ->
            @addSimpleTest "1-1a", "output O:2/0 is on when I:1/0 and I:1/1 are on", 2, [true, true, false], [0]
            @addSimpleTest "1-1a", "output O:2/0 is on when I:1/2 is on", 1, [false, true, true], [0]
            @addSimpleTest "1-1a", "output O:2/0 is off otherwise", 1, [true, false, false], []

        add_1_1_b_tests: ->
            @addSimpleTest "1-1b", "output O:2/0 is on when I:1/0 and I:1/1 are on", 1, [true, true, false], [0]
            @addSimpleTest "1-1b", "output O:2/0 is on when I:1/2 and I:1/1 are on", 1,  [false, true, true], [0]
            @addSimpleTest "1-1b", "output O:2/0 is off otherwise", 2, [true, false, true], []

        add_1_1_c_tests: ->
            @addSimpleTest "1-1c", "output O:2/0 is on when I:1/0, I:1/1, and I:1/2 are on", 1, [true,true,true], [0]
            @addSimpleTest "1-1c", "output O:2/0 is off when I:1/0 is off", 1, [false, true, true], []
            @addSimpleTest "1-1c", "output O:2/0 is off when I:1/1 is off", 1, [true, false, true], []
            @addSimpleTest "1-1c", "output O:2/0 is off when I:1/2 is off", 1, [true, true, false], []

        add_1_1_d_tests: ->
            @addSimpleTest "1-1d", "output O:2/0 is on when I:1/0 is on", 1, [true, false, false], [0]
            @addSimpleTest "1-1d", "output O:2/0 is on when I:1/1 is on", 1, [false, true, false], [0]
            @addSimpleTest "1-1d", "output O:2/0 is on when I:1/2 is on", 1, [false, false, true], [0]
            @addSimpleTest "1-1d", "output O:2/0 is off when all inputs off", 1, [false, false, false], []

        add_1_2_tests: ->
            @addSimpleTest "1-2", "output O:2/0 is on when I:1/0 and I:1/1 are on", 1, [true, true], [0]
            @addSimpleTest "1-2", "output O:2/0 is off when I:1/0 off", 1, [false, true], []
            @addSimpleTest "1-2", "output O:2/0 is off when I:1/1 off", 1, [true, false], []

        add_1_3_tests: ->
            @addSimpleTest "1-3", "output O:2/0 is off when I:1/0 and I:1/1 are both off", 1, [false, false], []
            @addSimpleTest "1-3", "output O:2/0 is on when I:1/0 on", 1, [false, true], [0]
            @addSimpleTest "1-3", "output O:2/0 is on when I:1/1 on", 1, [true, false], [0]            
            

        add_1_4_tests: ->
            @addSimpleTest "1-4", "output O:2/0 is on when I:1/0 and I:1/1 are on", 1, [true, true, false, false], [0]
            @addSimpleTest "1-4", "output O:2/0 is on when I:1/2 and I:1/3 are on", 1, [false, false, true, true], [0]
            @addSimpleTest "1-4", "output O:2/0 is off unless either I:1/0 and I:1/1 or I:1/2 and I:1/3 are on", 1, [false, true, false, true], []

        add_1_5_tests: ->
            @addSimpleTest "1-5", "output O:2/0 is on when I:1/0 and I:1/1 are on", 2, [true, true, false], [0]
            @addSimpleTest "1-5", "output O:2/0 is on when I:1/0 and I:1/2 are on", 2, [true, false, true], [0]
            @addSimpleTest "1-5", "output O:2/0 is off when I:1/0 off", 1, [false, true, false], []

        add_1_6_tests: ->
            @addSimpleTest "1-6", "output O:2/0 is on when all of inputs 0, 4, 5, and one of inputs 1, 2, and 3 is on", 4, [true, true, false, false, true, true], [0]
            @addSimpleTest "1-6", "output O:2/0 is off unless inputs 0, 4, 5 are all on and one of inputs 1, 2, and 3 is on", 3, [false, true, false, false, true, true], []

        add_2_1_tests: ->
            @simpleAdd "2-1", "output O:2/7 is on when input I:1/1 is on", 2, {1:true}, {}, {7:true}
            @simpleAdd "2-1", "output O:2/2 is on when input I:1/8 is on", 2, {8:true}, {}, {2:true}

        add_2_2_tests: ->
            for on_off, bit in ["on", "off", "on", "on", "off", "on", "on", "on", "off", "off", "on", "on", "off", "off", "on", "off"]
                input = {}
                output = {}
                input[bit] = true
                output[bit] = on_off == "on"
                @simpleAdd "2-2", "O:2/#{bit} turns #{on_off} when I:1/#{bit} is on", 1, input, {}, output

    module.exports = Grader_ch1_2
).call this
(->
    "use strict"
    RSLParser = require "../models/RSLParser.coffee"
    DataTable = require "../models/dataTable.coffee"
    fs = require "fs"
    Grader = require "./grader.coffee"
    Find = require "../models/RSLParser/find.coffee"

    f = false
    t = true

    

    class Grader_ch6 extends Grader
        constructor: (@folderPath)->
            super @folderPath
            @initializeProblems()
            @run()

        initializeProblems: ->
            super()
            @add_01()
            @add_02()
            @add_03()
            @add_04()
            @add_05()
            @add_11()
            @add_12()
            @add_14()
            @add_15()
            @add_20()
            @add_21()
            @add_23()
            @add_24()
            @add_25()
            @add_27()
            @add_28()
            @add_29()
            @add_30()
            @add_31()
            @add_34()

        add_01: ->
            @simpleAdd "6-01", "output O:2/0 turns on when I:1/0 on", 1, {0:true}, {0:false}, {0:true}
            @simpleAdd "6-01", "output O:2/2 turns on when I:1/0 on", 1, {0:true}, {2:false}, {2:true}
            @simpleAdd "6-01", "output O:2/1 turns on when I:1/0 off", 1, {0:false}, {1:false}, {1:true}
            @simpleAdd "6-01", "output O:2/3 turns on when I:1/0 off", 1, {0:false}, {1:false}, {3:true}
            @simpleAdd "6-01", "outputs O:2/0 and O:2/2 off when I:1/0 off", 1, {0:false}, {0:false, 1:false, 2:false, 3:false}, {0:false, 1:true, 2:false, 3:true}
            @simpleAdd "6-01", "outputs O:2/1 and O:2/3 off when I:1/0 on", 1, {0:true}, {0:false, 1:false, 2:false, 3:false}, {0:true, 1:false, 2:true, 3:false}

        add_02: ->

        add_03: ->
            @add_03a()
            @add_03b()
            @add_03c()

        add_03a: ->

        add_03b: ->

        add_03c: ->

        add_04: ->

        add_05: ->

        add_11: ->
            @add_11a()
            @add_11b()

        add_11a: ->

        add_11b: ->

        add_12: ->

        add_14: ->
            @add_14a()
            @add_14b()

        add_14a: ->

        add_14b: ->

        add_15: ->

        add_20: ->

        add_21: ->
            @add_21a()
            @add_21b()

        add_21a: ->

        add_21b: ->

        add_23: ->

        add_24: ->

        add_25: ->

        add_27: ->

        add_28: ->

        add_29: ->

        add_30: ->

        add_31: ->

        add_34: ->

        @simpleDataTable: class simpleDataTable
            constructor: (inputBits, outputBits)->
                @I = {1: {}}
                for bit, value of inputBits
                    @I[1][bit] = value

                @O = {2: {}}
                for bit, value of outputBits
                    @O[2][bit] = value

        simpleAdd: (name, desc, points, inputBits, outputBitsStart, outputBitsFinish)->
            @addTest name, desc, points, new Grader_ch6.simpleDataTable(inputBits, outputBitsStart), new Grader_ch6.simpleDataTable(inputBits, outputBitsFinish)

    module.exports = Grader_ch6
).call this
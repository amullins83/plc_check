(->
    "use strict"
    RSLParser = require "../models/RSLParser.coffee"
    Timer = require("../models/RSLParser/RSLCounterTimer.coffee").Timer
    DataTable = require "../models/dataTable.coffee"
    fs = require "fs"
    Grader = require "./grader.coffee"
    Find = require "../models/RSLParser/find.coffee"

    class Grader_ch4 extends Grader
        constructor: (@folderPath)->
            super @folderPath
            @initializeTestTimers()
            @initializeProblems()
            @run()

        initializeProblems: ->
            super()
            @add_01()
            @add_02()
            @add_03()
            @add_04()
            @add_05()
            @add_07()
            @add_09()
            @add_10()
            @add_11()
            @add_12()
            @add_13()
            @add_14()
            @add_15()
            @add_16()
            @add_17()
            @add_18()
            @add_19()
            @add_20()
            @add_21()
            @add_22()
            @add_23()
            @add_24()
            @add_25()
            @add_26()
            @add_27()

        add_01: ->
        
        add_02: ->
        
        add_03: ->

        add_04: ->
        
        add_05: ->
        
        add_06: ->        

        add_07: ->
        
        add_08: ->
        
        add_09: ->

        add_10: ->
        
        add_11: ->
        
        add_12: ->

        add_13: ->
        
        add_14: ->
        
        add_15: ->

        add_16: ->
        
        add_17: ->
        
        add_18: ->

        add_19: ->
        
        add_20: ->
        
        add_21: ->

        add_22: ->
        
        add_23: ->
        
        add_24: ->

        add_25: ->
        
        add_26: ->
        
        add_27: ->


    module.exports = Grader_ch4
).call this
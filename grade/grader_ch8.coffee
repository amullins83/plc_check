(->
    "use strict"
    RSLParser = require "../models/RSLParser.coffee"
    RSLCounterTimer = require("../models/RSLParser/RSLCounterTimer.coffee")
    Counter = RSLCounterTimer.Counter
    Timer = RSLCounterTimer.Timer
    DataTable = require "../models/dataTable.coffee"
    fs = require "fs"
    Grader = require "./grader.coffee"
    Find = require "../models/RSLParser/find.coffee"

    class Grader_ch8 extends Grader
        constructor: (@folderPath)->
            super @folderPath
            @initializeProblems()
            @run()

        initializeProblems: ->
            super()
            @add_01()
            @add_02()
            @add_03()
            @add_07()
            @add_22()
            @add_38()

        makeCounter1: (counter, preset)->
            c = new Counter counter, preset
            c.CU()
            return c

        makeCounterDone: (counter, preset)->
            c = new Counter counter, preset
            c.CU() until c.dn
            return c            

        checkPreset: (problem, counter, preset, inputObject)->
            outputObject = {C5: {}}
            outputObject.C5[counter] = {preset: preset}
            @addTest problem, "counter C5:#{counter} preset is #{preset}", 1, inputObject, outputObject

        checkOutputStateWhenCounterDone: (problem, output, state, counter, preset, inputObject)->
            outputObject = {O: {2: {}}}
            outputObject.O[2][output] = state

            @addTest problem, "output O:2/#{output} is on when counter C5:#{counter} done", 2, @makeCounterDoneInputObject(counter, preset, inputObject), outputObject

        makeCounterDoneInputObject: (counter, preset, inputObject)->
            =>
                inputObject.C5 = inputObject.C5 || {}
                inputObject.C5[counter] = inputObject.C5[counter] || @makeCounterDone counter, preset
                return inputObject

        add_01: ->
# 1.    SOR,0 XIC,I:1/0 CTU,C5:1,7 EOR,0
#       SOR,1 XIC,C5:1/DN OTE,O:2/0 EOR,1
#       SOR,2 XIO,C5:1/DN OTE,O:2/1 EOR,2
#       SOR,3 XIC,I:1/1 RES,C5:1 EOR,3
#       SOR,4 END,4
            
            @addTest "8-01", "I:1/0 switching off to on causes counter C5:1 to count up", 3, {I: {1: {0:true}}}, {C5: {1: @makeCounter1 1, 7}}
            @addTest "8-01", "I:1/1 resets counter C5:1", 2, {I: {1: {1:true}}, C5: {1: @makeCounter1 1, 7}}, {C5: {1: {acc: 0}}}
            @checkPreset "8-01", 1, 7, {I: {1: {0:true}}}
            @checkOutputStateWhenCounterDone "8-01", 0, true, 1, 7, {}
            @checkOutputStateWhenCounterDone "8-01", 1, false, 1, 7, {}
            
            

        add_02: ->
# 2.    SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/0 BND,1 XIC,I:1/1 OTE,O:2/0 EOR,0
#       SOR,1 XIC,I:1/3 BST,1 CTU,C5:1,10 NXB,1 CTU,C5:2,32767 BND,1 EOR,1
#       SOR,2 XIC,C5:1/DN BST,1 OTE,B3:0/1 OTE,O:2/4 NXB,1 RES,C5:1 BND,1 EOR,2
#       SOR,3 XIC,B3:0/1 CTU,C5:3,300 EOR,3
#       SOR,4 XIC,I:1/6 BST,1 RES,C5:2 NXB,1 RES,C5:3 BND,1 EOR,4
#       SOR,5 END,5

            @simpleAdd "8-02", "O:2/0 starts when I:1/0 pressed", 2, {0:true, 1:true}, {}, {0:true}
            @simpleAdd "8-02", "O:2/0 stops when I:1/1 open", 2, {0:true, 1:false}, {0:true}, {0:false}
            @checkPreset "8-02", 1, 10, {I: {1: {3:true}}}
            @addTest "8-02", "counter C5:2 counts up when I:1/3 is on", 4, {I: {1: {3:true}}}, {C5: {2: {acc: 1}}}
            @checkPreset "8-02", 3, 300, {C5: {1: @makeCounterDone 1, 10}}
            @addTest "8-02", "counter C5:3 counts up when C5:1 is done", 4, {C5: {1: @makeCounterDone 1, 10}}, {C5: {3: {acc: 1}}}
            @addTest "8-02", "counter C5:1 resets when it is done", 3, {C5: {1: @makeCounterDone 1, 10}}, {C5: {1: {acc: 0}}}
            @addTest "8-02", "counter C5:2 resets when reset button is on", 3, {I: {1: {6:true}}, C5: {2: @makeCounter1 2, 3}}, {C5: {2: {acc: 0}}} 
            @addTest "8-02", "counter C5:3 resets when reset button is on", 3, {I: {1: {6:true}}, C5: {3: @makeCounter1 2, 3}}, {C5: {3: {acc: 0}}} 
            

        add_03: ->
# 3.    SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/0 BND,1 XIC,I:1/1 XIO,C5:0/DN OTE,O:2/0 EOR,0
#       SOR,1 XIC,I:1/3 CTU,C5:0,14 EOR,1
#       SOR,2 BST,1 XIC,I:1/6 NXB,1 XIC,C5:0/DN BND,1 RES,C5:0 EOR,2
#       SOR,3 END,3

            @simpleAdd "8-03", "points", 12, {}, {}, {}

        add_07: ->
            @add_07a()
            @add_07b()

        add_07a: ->
# 7.a.  SOR,0 XIC,I:1/0 CTU,C5:1,50 EOR,0
#       SOR,1 XIC,I:1/1 CTD,C5:1,50 EOR,1
#       SOR,2 XIC,I:1/2 RES,C5:1 EOR,2
#       SOR,3 END,3

            @add_07_base "a"

        add_07b: ->
# 7.b.  SOR,0 XIC,I:1/0 CTU,C5:1,10 EOR,0
#       SOR,1 XIC,I:1/1 CTD,C5:1,10 EOR,1
#       SOR,2 XIC,I:1/2 RES,C5:1 EOR,2
#       SOR,3 XIC,C5:1/DN OTE,O:2/0 EOR,3
#       SOR,4 END,4

            @add_07_base "b"
            @simpleAdd "8-07b", "points", 6, {}, {}, {}

        add_07_base: (letter)->
            @simpleAdd "8-07#{letter}", "points", 8, {}, {}, {}

        add_22: ->
# 22.   SOR,0 XIO,I:1/5 BST,1 XIC,I:1/3 XIC,I:1/1 XIO,C5:1/DN NXB,1 BST,2 XIC,O:2/0 XIO,C5:1/DN NXB,2 XIC,T4:2/DN XIO,I:1/2 BND,2 BND,1 OTE,O:2/0 EOR,0
#       SOR,1 XIC,I:1/4 XIO,I:1/5 CTU,C5:1,8 EOR,1
#       SOR,2 XIC,C5:1/DN XIO,I:1/5 RTO,T4:2,100 EOR,2
#       SOR,3 XIC,I:1/5 RES,T4:2 RES,C5:1 EOR,3
#       SOR,4 END,4

            @simpleAdd "8-22", "points", 24, {}, {}, {}


        add_38: ->
# 38.   SOR,0 XIC,I:1/1 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/5 BND,1 OTE,O:2/5 EOR,0
#       SOR,1 XIO,O:2/5 OTE,O:2/6 EOR,1
#       SOR,2 XIC,I:1/5 CTU,C5:1,100 EOR,2
#       SOR,3 XIC,O:2/5 XIO,C5:1/DN OTE,O:2/1 EOR,3
#       SOR,4 XIC,C5:1/DN RTO,T4:1,20 EOR,4
#       SOR,5 XIC,C5:1/DN XIO,T4:1/DN XIO,I:1/2 OTE,O:2/4 EOR,5
#       SOR,6 XIC,T4:1/DN XIO,I:1/4 XIO,T4:2/DN OTE,O:2/2 EOR,6
#       SOR,7 XIC,I:1/4 RTO,T4:2,100 EOR,7
#       SOR,8 XIC,T4:2/TT BST,1 OTE,O:2/0 NXB,1 OTE,O:2/7 BND,1 EOR,8 // Technically OK, I'd make it two rungs
#       SOR,9 XIC,T4:2/DN XIC,I:1/3 OTE,O:2/3 EOR,9
#       SOR,10 END,10

            @simpleAdd "8-38", "points", 38, {}, {}, {}

    module.exports = Grader_ch8
).call this
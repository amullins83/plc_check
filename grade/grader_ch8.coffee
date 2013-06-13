(->
    "use strict"
    RSLParser = require "../models/RSLParser.coffee"
    RSLCounterTimer = require("../models/RSLParser/RSLCounterTimer.coffee")
    Counter = RSLCounterTimer.Counter
    Timer = RSLCounterTimer.Timer
    DataTable = require "../models/dataTable.coffee"
    fs = require "fs"
    Grader = require "./grader.coffee"
    Find = require "../models/find.coffee"

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

        makeTimer1: (timer, preset)->
            t = new Timer timer, preset
            t.tick()
            t.en = true
            return t

        makeCounterDone: (counter, preset)->
            c = new Counter counter, preset
            c.CU() until c.dn
            return c

        makeTimerDone: (timer, preset)->
            t = new Timer timer, preset
            t.acc = preset
            t.en = true
            t.dn = true
            t.tt = false
            return t   

        checkCounterPreset: (problem, counter, preset, inputObject)->
            outputObject = {C5: {}}
            outputObject.C5[counter] = {preset: preset}
            @addTest problem, "counter C5:#{counter} preset is #{preset}", 1, inputObject, outputObject

        checkTimerPreset: (problem, timer, preset, inputObject)->
            outputObject = {T4: {}}
            outputObject.T4[timer] = {preset: preset}
            @addTest problem, "timer T4:#{timer} preset is #{preset}", 1, inputObject, outputObject

        checkOutputStateWhenTimerDone: (problem, output, state, timer, preset, inputObject)->
            outputObject = {O: {2: {}}}
            outputObject.O[2][output] = state
            on_off = if state then "on" else "off"
            @addTest problem, "output O:2/#{output} is #{on_off} when counter T4:#{timer} done", 2, @makeTimerDoneInputObject(timer, preset, inputObject), outputObject


        checkOutputStateWhenCounterDone: (problem, output, state, counter, preset, inputObject)->
            outputObject = {O: {2: {}}}
            outputObject.O[2][output] = state
            on_off = if state then "on" else "off"
            @addTest problem, "output O:2/#{output} is #{on_off} when counter C5:#{counter} done", 2, @makeCounterDoneInputObject(counter, preset, inputObject), outputObject

        makeCounterDoneInputObject: (counter, preset, inputObject)->
            =>
                inputObject.C5 = inputObject.C5 || {}
                inputObject.C5[counter] = inputObject.C5[counter] || @makeCounterDone counter, preset
                return inputObject

        makeTimerDoneInputObject: (timer, preset, inputObject)->
            =>
                inputObject.T4 = inputObject.T4 || {}
                inputObject.T4[counter] = inputObject.T4[counter] || @makeTimerDone timer, preset
                return inputObject



        add_01: ->
# 1.    SOR,0 XIC,I:1/0 CTU,C5:1,7 EOR,0
#       SOR,1 XIC,C5:1/DN OTE,O:2/0 EOR,1
#       SOR,2 XIO,C5:1/DN OTE,O:2/1 EOR,2
#       SOR,3 XIC,I:1/1 RES,C5:1 EOR,3
#       SOR,4 END,4
            
            @addTest "8-01", "I:1/0 switching off to on causes counter C5:1 to count up", 3, {I: {1: {0:true}}}, {C5: {1: @makeCounter1 1, 7}}
            @addTest "8-01", "I:1/1 resets counter C5:1", 2, {I: {1: {1:true}}, C5: {1: @makeCounter1 1, 7}}, {C5: {1: {acc: 0}}}
            @checkCounterPreset "8-01", 1, 7, {I: {1: {0:true}}}
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
            @checkCounterPreset "8-02", 1, 10, {I: {1: {3:true}}}
            @addTest "8-02", "counter C5:2 counts up when I:1/3 is on", 4, {I: {1: {3:true}}}, {C5: {2: {acc: 1}}}
            @checkCounterPreset "8-02", 3, 300, {C5: {1: @makeCounterDone 1, 10}}
            @addTest "8-02", "counter C5:3 counts up when C5:1 is done", 4, {C5: {1: @makeCounterDone 1, 10}}, {C5: {3: {acc: 1}}}
            @addTest "8-02", "counter C5:1 resets when it is done", 3, {C5: {1: @makeCounterDone 1, 10}}, {C5: {1: {acc: 0}}}
            @addTest "8-02", "counter C5:2 resets when reset button is on", 3, {I: {1: {6:true}}, C5: {2: @makeCounter1 2, 3}}, {C5: {2: {acc: 0}}} 
            @addTest "8-02", "counter C5:3 resets when reset button is on", 3, {I: {1: {6:true}}, C5: {3: @makeCounter1 2, 3}}, {C5: {3: {acc: 0}}} 
            

        add_03: ->
# 3.    SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/0 BND,1 XIC,I:1/1 XIO,C5:0/DN OTE,O:2/0 EOR,0
#       SOR,1 XIC,I:1/3 CTU,C5:0,14 EOR,1
#       SOR,2 BST,1 XIC,I:1/6 NXB,1 XIC,C5:0/DN BND,1 RES,C5:0 EOR,2
#       SOR,3 END,3
            @simpleAdd "8-03", "O:2/0 turns on when I:1/0 and I:1/1 on and C5:0 not done", 1, {0:true, 1:true}, {}, {0:true}
            @addOrTest "8-03", "C5:0 preset is either 13 or 14 (depends on implementation, rung order, etc.).", 4, [{I: {1: {3:true}}}, {I: {1: {3:true}}}], [{C5: {0: {preset: 13}}}, {C5: {0: {preset: 14}}}]
            @addTest "8-03", "C5:0 resets when I:1/6 is on", 2, {I: {1: {3:true, 6:true}}}, {C5: {0: {acc: 0}}}
            @addTest "8-03", "C5:0 resets when preset count is reached", 3, {C5: {0: @makeCounterDone 0, 14}}, {C5: {0: {acc: 0}}}
            @addTest "8-03", "O:2/0 stops when C5:0 done", 2, {I: {1: {1:true}}, C5: {0: @makeCounterDone 0, 14}}, {O: {2: {0:false}}}
            

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
            @checkCounterPreset "8-07b", 1, 10, {I: {1: {0:true}}}
            @checkCounterPreset "8-07b", 1, 10, {I: {1: {1:true}}}
            @addTest "8-07b", "O:2/0 turns on when C5:1 done", 4, {C5: {1: @makeCounterDone 1, 10}}, {O: {2: {0:true}}}
            

        add_07_base: (letter)->
            @addTest "8-07#{letter}", "C5:1 counts up when I:1/0 is on", 3, {I: {1: {0:true}}}, {C5: {1: {acc: 1}}}
            @addTest "8-07#{letter}", "C5:1 counts down when I:1/1 is on", 3, {I: {1: {0:false, 1:true}}, C5: {1: @makeCounter1 1, 50}}, {C5: {1: {acc: 0}}}
            @addTest "8-07#{letter}", "C5:1 resets when I:1/2 is pressed", 2, {I: {1: {2:true}}, C5: {1: @makeCounterDone 1, 50}}, {C5: {1: {acc: 0}}}
            

        add_22: ->
# 22.   SOR,0 XIO,I:1/5 BST,1 XIC,I:1/3 XIC,I:1/1 XIO,C5:1/DN NXB,1 BST,2 XIC,O:2/0 XIO,C5:1/DN NXB,2 XIC,T4:2/DN XIO,I:1/2 BND,2 BND,1 OTE,O:2/0 EOR,0
#       SOR,1 XIC,I:1/4 XIO,I:1/5 CTU,C5:1,8 EOR,1
#       SOR,2 XIC,C5:1/DN XIO,I:1/5 RTO,T4:2,100 EOR,2
#       SOR,3 XIC,I:1/5 RES,T4:2 RES,C5:1 EOR,3
#       SOR,4 END,4
            @simpleAdd "8-22", "O:2/0 turns on if I:1/5 off, I:1/3 and I:1/1 on and C5:1 not done", 4, {1:true, 3:true}, {}, {0:true}
            @simpleAdd "8-22", "O:2/0 stays on if I:1/5 off and C5:1 not done", 3, {}, {0:true}, {0:true}
            @addTest "8-22", "O:2/0 turns on if I:1/2 and I:1/5 are off and timer T4:2 is done", 3, {T4: {2: @makeTimerDone 2, 100}}, {O: {2: {0:true}}}
            @simpleAdd "8-22", "O:2/0 turns off if I:1/5 is on", 1, {1:true, 3:true, 5:true}, {0:true}, {0:false}
            @addTest "8-22", "counter C5:1 counts up when I:1/4 on", 3, {I: {1: {4: true}}}, {C5: {1: {acc: 1}}}
            @checkCounterPreset "8-22", 1, 8, {I: {1: {4:true}}}
            @addTest "8-22", "timer T4:2 enables when C5:1 done", 3, {C5: {1: @makeCounterDone 1, 8}}, {T4: {2: {en:true}}}
            @checkTimerPreset "8-22", 2, 100, {C5: {1: @makeCounterDone 1, 8}}
            @addTest "8-22", "pressing I:1/5 resets counter", 3, {I: {1: {5:true}}, C5: {1: @makeCounterDone 1, 8}}, {C5: {1: {acc: 0}}}
            @addTest "8-22", "pressing I:1/5 resets timer", 2, {I: {1: {5:true}}, T4: {2: @makeTimerDone 2, 100}}, {T4: {2: {acc: 0}}}
            
        add_38: ->
# 38.   SOR,0 XIC,I:1/1 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/5 BND,1 OTE,O:2/5 EOR,0
#       SOR,1 XIO,O:2/5 OTE,O:2/6 EOR,1
#       SOR,2 XIC,I:1/5 CTU,C5:1,100 EOR,2
#       SOR,3 XIC,O:2/5 XIO,C5:1/DN OTE,O:2/1 EOR,3
#       SOR,4 XIC,C5:1/DN RTO,T4:1,20 EOR,4
#       SOR,5 XIC,C5:1/DN XIO,T4:1/DN XIO,I:1/2 OTE,O:2/4 EOR,5
#       SOR,6 XIC,T4:1/DN XIO,I:1/4 XIO,T4:2/DN OTE,O:2/2 EOR,6
#       SOR,7 XIC,I:1/4 RTO,T4:2,100 EOR,7
#       SOR,8 XIC,T4:2/TT BST,1 OTE,O:2/0 NXB,1 OTE,O:2/7 BND,1 EOR,8
#       SOR,9 XIC,T4:2/DN XIC,I:1/3 OTE,O:2/3 EOR,9
#       SOR,10 END,10

            @simpleAdd "8-38", "pump 1 turns on when start button pressed", 2, {0:true, 1:true}, {5:true}, {1:true}
            @addTest "8-38", "C5:1 counts up when flowmeter switch is on", 2, {I: {1: {1:true, 3:true, 5:true}}, O: {2: {5:true}}}, {C5: {1: {acc:1}}}
            @addTest "8-38", "pump 1 stops when counter reaches 100", 4, {I: {1: {1:true, 3:true}}, C5: {1: @makeCounterDone 1, 100}, O: {2: {1:true, 5:true}}}, {O: {2: {1:false}}}
            @addTest "8-38", "heater is on when T4:1 is timing and temperature below limit", 3, {I: {1: {1:true, 3:true}}, C5: {1: @makeCounterDone 1, 100}, T4: {2: @makeTimer1 2, 20}, O: {2: {5:true}}}, {O: {2: {4:true}}}
            @addTest "8-38", "heater stops when T4:1 is done", 4, {I: {1: {1:true, 3:true}}, C5: {1: @makeCounterDone 1, 100}, T4: {1: @makeTimerDone 1, 20}, O: {2: {4:true, 5:true} }}, {O: {2: {4:false}}}
            @addTest "8-38", "pump 2 starts when T4:1 is done", 2, {I: {1: {1:true, 3:true}}, C5: {1: @makeCounterDone 1, 100}, T4: {1: @makeTimerDone 1, 20}, O: {2: {5:true}}}, {O: {2: {2:true}}}
            @addTest "8-38", "pump 2 stops when tank is full", 4, {I: {1: {1:true, 3:true, 4:true}}, C5: {1: @makeCounterDone 1, 100}, T4: {1: @makeTimerDone 1, 20}, O: {2: {2:true, 5:true, 7:true}}}, {O: {2: {2:false}}}
            @addTest "8-38", "mixer starts when tank is full", 2, {I: {1: {1:true, 3:true, 4:true}}, C5: {1: @makeCounterDone 1, 100}, T4: {1: @makeTimerDone 1, 20}, O: {2: {2:true, 5:true, 7:true}}}, {O: {2: {0:true}}}
            @checkTimerPreset "8-38", 2, 100, {I: {1: {1:true, 3:true, 4:true}}, C5: {1: @makeCounterDone 1, 100}, T4: {1: @makeTimerDone 1, 20}, O: {2: {5:true, 7:true}}}
            @addTest "8-38", "mixer stops after ten seconds", 4, {I: {1: {1:true, 3:true, 4:true}}, C5: {1: @makeCounterDone 1, 100}, T4: {1: @makeTimerDone(1, 20), 2: @makeTimerDone(2, 100)}, O: {2: {0:true, 5:true, 7:true}}}, {O: {2: {0:false}}}
            @addTest "8-38", "pump 3 starts when mixer stops", 4, {I: {1: {1:true, 3:true, 4:true}}, C5: {1: @makeCounterDone 1, 100}, T4: {1: @makeTimerDone(1, 20), 2: @makeTimerDone(2, 100)}, O: {2: {5:true}}}, {O: {2: {3:true}}}
            @addTest "8-38", "pump 3 keeps going until tank is empty", 4, {I: {1: {1:true, 3:true}}, C5: {1: @makeCounterDone 1, 100}, T4: {1: @makeTimerDone(1, 20), 2: @makeTimerDone(2, 100)}, O: {2: {3:true, 5:true}}}, {O: {2: {3:true}}}
            @addTest "8-38", "pump 3 stops when tank is empty", 2, {I: {1: {1:true}}, C5: {1: @makeCounterDone 1, 100}, T4: {1: @makeTimerDone(1, 20), 2: @makeTimerDone(2, 100)}, O: {2: {3:true, 5:true}}}, {O: {2: {3:false}}}
            

    module.exports = Grader_ch8
).call this
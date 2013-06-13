(->
    "use strict"
    RSLParser = require "../models/RSLParser.coffee"
    Timer = require("../models/RSLParser/RSLCounterTimer.coffee").Timer
    DataTable = require "../models/dataTable.coffee"
    fs = require "fs"
    Grader = require "./grader.coffee"
    Find = require "../models/find.coffee"

    class Grader_ch7 extends Grader
        constructor: (@folderPath)->
            super @folderPath
            @initializeTestTimers()
            @initializeProblems()
            @run()

        initializeTestTimers: ->
            @make_t4_0_about_done()
            @make_t4_0_timing()

        make_t4_0_about_done: ->
            @t4_0_about_done = @make_timer_on_about_done 0, 100

        make_t4_0_timing: ->
            @t4_0_timing = @make_timer_on_timing 0, 100

        make_timer_on_timing: (timer, preset)->
            t = new Timer timer, preset
            t.tick()
            t.en = true
            return t

        make_timer_on_about_done: (timer, preset)->
            t = new Timer timer, preset
            t.en = true
            t.acc = preset - 1
            return t

        make_timer_off_timing: (timer, preset)->
            t = new Timer timer, preset
            t.tick()
            t.en = true
            t.dn = true
            return t

        make_timer_off_about_done: (timer, preset)->
            t = new Timer timer, preset
            t.acc = preset - 1
            t.en = false
            t.dn = true
            return t

        initializeProblems: ->
            super()
            @add_01()
            @add_05()
            @add_07()
            @add_09()
            @add_10()
            @add_13()
            @add_17()
            @add_22()

        checkPreset: (problem, timer, preset, inputObject)->
            outputObject = {T4: {}}
            outputObject.T4[timer] = {preset: preset}
            @addTest problem, "timer T4:#{timer} preset is #{preset}", 1, inputObject, outputObject

        checkOutputOnWhenTimerDone: (problem, output, timer, preset, inputObject)->
            outputObject = {O: {2: {}}}
            outputObject.O[2][output] = true
            
            @addOrTest problem, "output O:2/#{output} is on when timer T4:#{timer} done", 1, [@makeTimerOnAboutDoneInputObject timer, preset, inputObject, @makeTimerOffAboutDoneInputObject timer, preset, inputObject], [outputObject, outputObject]

        checkOutputOffWhenTimerDone: (problem, output, timer, preset, inputObject)->
            outputObject = {O: {2: {}}}
            outputObject.O[2][output] = false
            
            @addOrTest problem, "output O:2/#{output} is off when timer T4:#{timer} done", 1, [@makeTimerOnAboutDoneInputObject timer, preset, inputObject, @makeTimerOffAboutDoneInputObject timer, preset, inputObject], [outputObject, outputObject]

        makeTimerOnAboutDoneInputObject: (timer, preset, inputObject)->
            =>
                inputObject.T4 = inputObject.T4 || {}
                inputObject.T4[timer] = inputObject.T4[timer] || @make_timer_on_about_done timer, preset
                return inputObject

        makeTimerOffAboutDoneInputObject: (timer, preset, inputObject)->
            =>
                inputObject.T4 = inputObject.T4 || {}
                inputObject.T4[timer] = inputObject.T4[timer] || @make_timer_off_timing timer, preset
                return inputObject

        add_01: ->
        # SOR,0 XIC,I:1/0 TON,T4:0,100 EOR,0
        # SOR,1 XIC,T4:0/DN OTE,O:2/0 EOR,1

            @addTest "7-01", "timer T4:0 enables when I:1/0 is on", 2, {I: {1: {0:true}}}, {T4: {0: {en: true}}}
            @checkPreset "7-01", 0, 100, {I: {1: {0:true}}}
            @addTest "7-01", "output O:2/0 is on when timer T4:0 is done", 3, {I: {1: {0:true}}, T4: {0: @t4_0_about_done}, O: {2: {0:false}}}, {T4: {0: {dn: true}}, O: {2: {0:true}}}
            
        add_05: ->
        # SOR,0 XIC,I:1/0 TON,T4:0,100 EOR,0
        # SOR,1 XIC,T4:0/EN OTE,O:2/0 EOR,1
        # SOR,2 XIC,T4:0/TT OTE,O:2/1 EOR,2
        # SOR,3 XIC,T4:0/DN OTE,O:2/2 EOR,3

            @addTest "7-05", "timer T4:0 enables when I:1/0 is on", 4, {I: {1: {0:true}}}, {T4: {0: {en: true}}}
            @addTest "7-05", "output O:2/0 is on when T4:0 enabled", 2, {I: {1: {0:true}}, T4: {0: @t4_0_about_done}, O: {2: {0:false}}}, {O: {2: {0:true}}}
            @addTest "7-05", "output O:2/1 is on when T4:0 timing", 2, {I: {1: {0:true}}, T4: {0: @t4_0_timing}, O: {2: {1:false}} }, {O: {2: {1:true}}}
            @addTest "7-05", "output O:2/2 is on when T4:0 done", 2, {I: {1: {0:true}}, T4: {0: @t4_0_about_done}, O: {2: {2:false}}}, {O: {2: {2:true}}}
            
        add_07: ->
        # SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,T4:0/EN BND,1 XIC,I:1/1 TON,T4:0,100 EOR,0
        # SOR,1 XIO,T4:0/DN XIC,T4:0/EN OTE,O:2/3 EOR,1
        # SOR,2 XIC,T4:0/DN OTE,O:2/0 EOR,2

            @addTest "7-07", "timer T4:0 enables when I:1/0 and I:1/1 are on", 2, {I: {1: {0:true, 1:true}}}, {T4: {0: {en: true}}}
            @addTest "7-07", "timer T4:0 preset is 100", 1, {I: {1: {0:true, 1:true}}}, {T4: {0: {preset: 100}}}
            @addTest "7-07", "timer T4:0 remains enabled when I:1/0 off", 2, {I: {1: {0:false, 1:true}}, T4: {0: @t4_0_timing}}, {T4: {0: {en:true}}}
            @addTest "7-07", "timer T4:0 resets when I:1/1 off", 2, {I: {1: {0:true, 1:false}}, T4: {0: @t4_0_timing}}, {T4: {0: {en:false, acc:0}}}
            @t4_0_timing = @make_t4_0_timing()
            @addTest "7-07", "output O:2/3 turns on when timer enabled but not done", 2, {I: {1: {1:true}}, T4: {0: @t4_0_timing}, O: {2: {3:false}}}, {O: {2: {3:true}}}
            @addTest "7-07", "output O:2/0 turns on when timer done", 2, {I: {1: {1:true}}, T4: {0: @t4_0_about_done}, O: {2: {0:false}}}, {O: {2: {0:true}}}

        add_09: ->
        # SOR,0 XIC,I:1/0 BST,1 TOF,T4:1,50 NXB,1 BST,2 TOF,T4:2,100 NXB,2 TOF,T4:3,150 BND,2 BND,1 EOR,0
        # SOR,1 XIC,T4:1/DN OTE,O:2/0 EOR,1
        # SOR,2 XIC,T4:2/DN OTE,O:2/1 EOR,2
        # SOR,3 XIC,T4:3/DN OTE,O:2/2 EOR,3

            @addTest "7-09", "timer T4:1 enables when I:1/0 is on", 1, {I: {1: {0:true}}}, {T4: {1:{en:true}}}
            @addTest "7-09", "timer T4:2 enables when I:1/0 is on", 1, {I: {1: {0:true}}}, {T4: {2:{en:true}}}
            @addTest "7-09", "timer T4:3 enables when I:1/0 is on", 1, {I: {1: {0:true}}}, {T4: {1:{en:true}}}
            @checkPreset "7-09", 1, 50, {I: {1: {0:true}}}
            @checkPreset "7-09", 2, 100, {I: {1: {0:true}}}
            @checkPreset "7-09", 3, 150, {I: {1: {0:true}}}
            @addTest "7-09", "timer T4:1 starts counting when I:1/0 is off", 3, {I: {1: {0:false}}, T4: {1: @make_timer_off_timing 1, 50}}, {T4: {1: {tt:true}}}
            @addTest "7-09", "timer T4:2 starts counting when I:1/0 is off", 2, {I: {1: {0:false}}, T4: {2: @make_timer_off_timing 2, 100}}, {T4: {2: {tt:true}}}
            @addTest "7-09", "timer T4:3 starts counting when I:1/0 is off", 2, {I: {1: {0:false}}, T4: {3: @make_timer_off_timing 3, 150}}, {T4: {3: {tt:true}}}
            @checkOutputOnWhenTimerDone "7-09", 0, 1,  50, {I: {1: {0:true}}}
            @checkOutputOnWhenTimerDone "7-09", 1, 2, 100, {I: {1: {0:true}}}
            @checkOutputOnWhenTimerDone "7-09", 2, 3, 150, {I: {1: {0:true}}}

        add_10: ->
        # SOR,0 XIC,I:1/0 TOF,T4:0,50 EOR,0
        # SOR,1 XIO,T4:0/DN OTE,O:2/0 EOR,1
        # SOR,2 XIC,T4:0/DN OTE,O:2/1 EOR,2
        # SOR,3 XIO,T4:0/EN OTE,O:2/2 EOR,3
        # SOR,4 XIC,T4:0/EN OTE,O:2/3 EOR,4

            @addTest "7-10", "timer T4:0 enables when I:1/0 is on", 2, {I: {1: {0:true}}}, {T4: {0:{en:true}}}
            @addTest "7-10", "output O:2/0 off when timer T4:0 is done", 3, {I: {1: {0:true}}, T4: {0: @make_timer_off_timing 0, 50}}, {O: {2: {0:false}}}
            @checkOutputOnWhenTimerDone "7-10", 1, 0, 50, {I: {1: {0:true}}}
            @addTest "7-10", "output O:2/2 off when timer T4:0 is enabled", 3, {I: {1: {0:true}}, O: {2: {2:true}}}, {O: {2: {2:false}}}
            @addTest "7-10", "output O:2/3 on when timer T4:0 is enabled", 3, {I: {1: {0:true}}, O: {2: {3:false}}}, {O: {2: {3:true}}}

        add_13: ->
        # SOR,0 XIC,I:1/0 XIO,T4:2/DN BST,1 TON,T4:0,100 NXB,1 TOF,T4:1,150 BND,1 EOR,0
        # SOR,1 XIC,T4:1/DN OTE,O:2/0 EOR,1
        # SOR,2 XIC,T4:0/DN OTE,O:2/1 EOR,2
        # SOR,3 XIC,I:1/1 RES,T4:2 EOR,3
        # SOR,4 XIC,O:2/0 RTO,T4:2,108000 EOR,4
        # SOR,5 XIC,T4:2/DN OTE,O:2/2 EOR,5

            @checkPreset "7-13", 0, 100, {I: {1: {0: true}}, T4: {1: {dn: false}}}
            @checkPreset "7-13", 1, 150, {I: {1: {0: true}}, T4: {1: {dn: false}}}
            @checkPreset "7-13", 2, 108000, {I: {1: {0: true}}, T4: {1: {dn: false}}}

            @addTest "7-13", "timer T4:0 enables when I:1/0 is on", 1, {I: {1: {0:true}}, T4: {2: {dn: false}}}, {T4: {0:{en:true}}}
            @addTest "7-13", "timer T4:1 enables when I:1/0 is on", 1, {I: {1: {0:true}}, T4: {2: {dn: false}}}, {T4: {1:{en:true}}}
            @addTest "7-13", "timer T4:2 enables when O:2/0 is on", 1, {I: {1: {0:true}}, T4: {2: {dn: false}}, O: {2: {0:true}}}, {T4: {2:{en:true}}}
            doneTimer = @make_timer_on_about_done 2, 108000
            doneTimer.tick()
            @addTest "7-13", "timer T4:0 resets when T4:2 is done", 1, {I: {1: {0:true}}, T4: {0: @make_timer_on_timing(0, 100), 2: doneTimer}}, {T4: {0: {acc: 0}}}
            @addTest "7-13", "timer T4:1 resets when I:1/0 is on", 1, {I: {1: {0:true}}, T4: {1: @make_timer_off_timing(1, 150), 2: {dn: false}}}, {T4: {1: {acc: 0}}}
            @addTest "7-13", "output O:2/2 turns on when T4:2 is done", 1, {T4: {2: doneTimer}}, {O: {2: {2:true}}}

            @addTest "7-13", "output O:2/1 turns on when T4:0 is done", 1, {I: {1: {0:true}}, T4: {0: @make_timer_on_about_done(0, 100), 2: {dn:false}}}, {O: {2: {1:true}}}
        
        add_17: ->
            @add_17a()
            @add_17b()

        add_17a: ->
        # SOR,0 XIO,T4:2/DN TON,T4:0,300 EOR,0
        # SOR,1 XIC,T4:0/DN TON,T4:1,250 EOR,1
        # SOR,2 XIC,T4:1/DN TON,T4:2,50 EOR,2
        # SOR,3 XIC,T4:0/EN XIO,T4:0/DN OTE,O:2/0 EOR,3
        # SOR,4 XIC,T4:1/EN XIO,T4:1/DN OTE,O:2/1 EOR,4
        # SOR,5 XIC,T4:2/EN XIO,T4:2/DN OTE,O:2/2 EOR,5   

            @add_17_base "a"
        
        add_17b: ->
        # SOR,0 XIO,T4:2/DN TON,T4:0,300 EOR,0
        # SOR,1 XIC,T4:0/DN TON,T4:1,250 EOR,1
        # SOR,2 XIC,T4:1/DN TON,T4:2,50 EOR,2
        # SOR,3 XIC,T4:0/EN XIO,T4:0/DN OTE,O:2/0 EOR,3
        # SOR,4 XIC,T4:1/EN XIO,T4:1/DN OTE,O:2/1 EOR,4
        # SOR,5 XIC,T4:2/EN XIO,T4:2/DN OTE,O:2/2 EOR,5
        # SOR,6 XIC,O:2/0 OTE,O:2/3 EOR,6

            @add_17_base "b"
            @addTest "7-17b", "output O:2/3 is on when O:2/0 is on", 1, {T4: {2: {dn:false}}, O: {2: {0:true}}}, {O: {2: {3:true}}}

        add_17_base: (letter)->
            @addTest "7-17#{letter}", "timer T4:2 not done enables T4:0", 1, {T4: {2: {dn:false}}}, {T4: {0: {en:true}}}
            @checkPreset "7-17#{letter}", 0, 300, {T4: {2: {dn: false}}}
            doneTimer0 = @make_timer_on_about_done 0, 300
            doneTimer0.tick()
            doneTimer1 = @make_timer_on_about_done 1, 250
            doneTimer1.tick()
            doneTimer2 = @make_timer_on_about_done 2,  50
            doneTimer2.tick()

            @checkPreset "7-17#{letter}", 1, 250, {T4: {0: doneTimer0, 2: {dn:false}}}
            @checkPreset "7-17#{letter}", 2,  50, {T4: {0: doneTimer0, 1: doneTimer1, 2: {dn:false}}}

            @addTest "7-17#{letter}", "output O:2/0 on when timer T4:0 timing", 2, {T4: {2: {dn:false}}}, {O: {2: {0:true, 1:false, 2:false}}}
            @addTest "7-17#{letter}", "output O:2/2 on when timer T4:1 timing", 2, {T4: {0: doneTimer0, 2: {dn:false}}}, {O: {2: {2:true, 0:false, 1:false}}}
            @addTest "7-17#{letter}", "output O:2/1 on when timer T4:2 timing", 1, {T4: {0: doneTimer0, 1: doneTimer1, 2: {dn:false}}}, {O: {2: {1:true, 0:false, 2:false}}}

        
        add_22: ->
        # SOR,0 XIC,I:1/2 RES,T4:0 EOR,0
        # SOR,1 XIC,I:1/0 RTO,T4:0,500 EOR,1
        # SOR,2 XIC,T4:0/EN OTE,O:2/0 EOR,2
        # SOR,3 XIO,T4:0/EN OTE,O:2/1 EOR,3
        # SOR,4 XIC,T4:0/DN OTE,O:2/2 EOR,4
        # SOR,5 XIO,T4:0/DN OTE,O:2/3

            @checkPreset "7-22", 0, 500, {I: {1: {0:true, 2:false}}}
            @addTest "7-22", "timer T4:0 enables when I:1/0 is on", 3, {I: {1: {0:true, 2:false}}}, {T4: {0: {en:true}}}
            @addTest "7-22", "timer T4:0 resets when I:1/2 is on", 3, {I: {1: {0:false, 2:true}}, T4: {0: @make_timer_on_about_done 0, 500}}, {T4: {0: {acc: 0}}}
            @addTest "7-22", "timer T4:0 retains count when I:1/0 is off", 3, {I: {1: {0:false, 2:false}}, T4: {0: @make_timer_on_about_done 0, 500}}, {T4: {0: {acc:499}}}
            @addTest "7-22", "output O:2/0 is on when T4:0 is enabled", 1, {I: {1: {0:true, 2:false}}}, {O: {2: {0:true}}}
            @addTest "7-22", "output O:2/1 is on when T4:0 is not enabled", 1, {I: {1: {0:false, 2:false}}}, {O: {2: {1:true}}}
            @addTest "7-22", "output O:2/2 is on when T4:0 is done", 1, {I: {1: {0:true, 2:false}}, T4: {0: @make_timer_on_about_done 0, 500}}, {O: {2: {2:true}}}
            @addTest "7-22", "output O:2/3 is on when T4:0 is not done", 1, {I: {1: {0:true, 2:false}}}, {O: {2: {3:true}}}


    module.exports = Grader_ch7
).call this
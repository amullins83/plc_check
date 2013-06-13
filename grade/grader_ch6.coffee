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
            # 6-01.rsl
            # SOR,0 XIC, I:1/0 BST,1 OTE,O:2/0 NXB,1 OTE,O:2/2 BND,1 EOR,0
            # SOR,1 XIO, I:1/0 BST,1 OTE,O:2/1 NXB,1 OTE,O:2/3 BND,1 EOR,1
            @simpleAdd "6-01", "output O:2/0 turns on when I:1/0 on", 1, {0:true}, {0:false}, {0:true}
            @simpleAdd "6-01", "output O:2/2 turns on when I:1/0 on", 1, {0:true}, {2:false}, {2:true}
            @simpleAdd "6-01", "output O:2/1 turns on when I:1/0 off", 1, {0:false}, {1:false}, {1:true}
            @simpleAdd "6-01", "output O:2/3 turns on when I:1/0 off", 1, {0:false}, {1:false}, {3:true}
            @simpleAdd "6-01", "outputs O:2/0 and O:2/2 off when I:1/0 off", 1, {0:false}, {0:false, 1:false, 2:false, 3:false}, {0:false, 1:true, 2:false, 3:true}
            @simpleAdd "6-01", "outputs O:2/1 and O:2/3 off when I:1/0 on", 1, {0:true}, {0:false, 1:false, 2:false, 3:false}, {0:true, 1:false, 2:true, 3:false}

        add_02: ->
            # 6-02.rsl
            # SOR,0 XIO,I:1/0 OTE,O:2/0 EOR,0
            # SOR,1 XIC,I:1/0 OTE,O:2/1 EOR,1
            @simpleAdd "6-02", "output O:2/0 turns on when I:1/0 off", 1, {0:false}, {0:false}, {0:true}
            @simpleAdd "6-02", "output O:2/0 turns off when I:1/0 on", 1, {0:true}, {0:false}, {0:false}
            @simpleAdd "6-02", "output O:2/1 turns on when I:1/0 on", 1, {0:true}, {1:false}, {1:true}
            @simpleAdd "6-02", "output O:2/1 turns off when I:1/0 off", 1, {0:false}, {1:false}, {1:false}

        add_03: ->
            @add_03a()
            @add_03b()
            @add_03c()

        add_03a: ->
        # 6-03a.rsl
        # SOR,0 XIC,I:1/1 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/0 BND,1 OTE,O:2/0 EOR,0
            @add_3_base "a"

        add_03b: ->
        # 6-03b.rsl
        # SOR,0 XIC,I:1/1 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/0 BND,1 BST,1 OTE,O:2/0 NXB,1 OTE,O:2/2 BND,1 EOR,0
        # SOR,1 XIO,O:2/0 OTE,O:2/3 EOR,1
            @add_3_base "b"
            @simpleAdd "6-03b", "output O:2/2 is on when O:2/0 is", 1, {0:true, 1:true}, {}, {2:true}
            @simpleAdd "6-03b", "output O:2/3 is off when O:2/0 is on", 1, {1:true}, {0:true}, {3:false}
            @simpleAdd "6-03b", "output O:2/3 is on when O:2/0 is off", 1, {1:false}, {0:false}, {3:true}

        add_03c: ->
        # 6-03c.rsl
        # SOR,0 XIC,I:1/1 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/0 BND,1 XIC,I:1/5 BST,1 OTE,O:2/0 NXB,1 OTE,O:2/2 BND,1 EOR,0
        # SOR,1 XIO,O:2/0 OTE,O:2/3 EOR,1
            @simpleAdd "6-03c", "output O:2/0 turns on when I:1/0, I:1/1, and I:1/5 on", 1, {0:true, 1:true, 5:true}, {0:false}, {0:true}
            @simpleAdd "6-03c", "output O:2/0 remains on when I:1/1 and I:1/5 on", 1, {0:false, 1:true, 5:true}, {0:true}, {0:true}
            @simpleAdd "6-03c", "output O:2/0 does not turn on when I:1/1 off", 1, {0:true, 1:false, 5:true}, {0:true}, {0:false}
            @simpleAdd "6-03c", "output O:2/0 does not turn on when I:1/5 off", 2, {0:true, 1:true, 5:false}, {0:true}, {0:false}

            @simpleAdd "6-03c", "output O:2/2 is on when O:2/0 is", 1, {0:true, 1:true, 5:true}, {}, {2:true}
            @simpleAdd "6-03c", "output O:2/3 is off when O:2/0 is on", 1, {1:true, 5:true}, {0:true}, {3:false}
            @simpleAdd "6-03c", "output O:2/3 is on when O:2/0 is off", 2, {1:false}, {0:false}, {3:true}

        add_3_base: (letter)->
            @simpleAdd "6-03#{letter}", "output O:2/0 turns on when I:1/0 and I:1/1 on", 1, {0:true, 1:true}, {}, {0:true}
            @simpleAdd "6-03#{letter}", "output O:2/0 remains on when I:1/1 on", 1, {0:false, 1:true}, {0:true}, {0:true}
            @simpleAdd "6-03#{letter}", "output O:2/0 does not turn on when I:1/1 off", 2, {0:true, 1:false}, {0:true}, {0:false}

        add_04: ->
        # 6-04.rsl
        # SOR,0 XIC,I:1/0 XIC,I:1/2 XIC,I:1/4 BST,1 XIC,I:1/1 NXB,1 BST,2 XIC,I:1/3 NXB,2 BST,3 XIC,I:1/5 NXB,3 XIC,O:2/0 BND,3 BND,2 BND,1 XIC,I:1/6 OTE,O:2/0 EOR,0
            @simpleAdd "6-04", "output O:2/0 turns on when all stop buttons closed and I:1/1 is closed", 1, {0:true, 1:true, 2:true, 3:false, 4:true, 5:false, 6:true}, {0:false}, {0:true}
            @simpleAdd "6-04", "output O:2/0 turns on when all stop buttons closed and I:1/3 is closed", 1, {0:true, 1:false, 2:true, 3:true, 4:true, 5:false, 6:true}, {0:false}, {0:true}
            @addOrTest "6-04", "output O:2/0 turns on when all stop buttons closed and I:1/5 is closed", 1, [{I: {1: {0:true, 1:false, 2:true, 3:false, 4:true, 5:true, 6:true}}, O: {2: {0:false}}}, {I: {1: {0:true, 1:false, 2:true, 3:false, 4:true, 5:true, 6:false}}, O: {2: {0:false}}}], [{O: {2: {0:true}}}, {O: {2: {0:true}}}]

            @simpleAdd "6-04", "output O:2/0 turns off when stop button I:1/0 is open", 1, {0:false, 1:false, 2:true, 3:false, 4:true, 5:false, 6:true}, {0:true}, {0:false}
            @simpleAdd "6-04", "output O:2/0 turns off when stop button I:1/2 is open", 1, {0:true, 1:false, 2:false, 3:false, 4:true, 5:false, 6:true}, {0:true}, {0:false}
            @simpleAdd "6-04", "output O:2/0 turns off when stop button I:1/4 is open", 1, {0:true, 1:false, 2:true, 3:false, 4:false, 5:false, 6:true}, {0:true}, {0:false}

            @simpleAdd "6-04", "output O:2/0 stays on if all stop buttons closed", 3, {0:true, 2:true, 4:true, 6:true}, {0:true}, {0:true}

        add_05: ->
        # 6-05.rsl
        # SOR,0 XIC,I:1/0 BST,1 XIC,I:1/1 NXB,1 XIC,O:2/0 BND,1 XIC,I:1/2 XIO,O:2/1 OTE,O:2/0 EOR,0
        # SOR,1 XIC,I:1/0 BST,1 XIC,I:1/1 NXB,1 XIC,O:2/1 BND,1 XIO,I:1/2 XIO,O:2/0 OTE,O:2/1 EOR,1

            @simpleAdd "6-05", "forward starts when start button pressed, selector switch is on, and reverse is off", 3, {0:true, 1:true, 2:true}, {0:false, 1:false}, {0:true}
            @simpleAdd "6-05", "reverse starts when start button pressed, selector switch is off, and forward is off", 3, {0:true, 1:true, 2:false}, {0:false, 1:false}, {1:true}
            @simpleAdd "6-05", "reverse stops when selector switch is on", 2, {0:true, 1:true, 2:true}, {0:false, 1:true}, {1:false}
            @simpleAdd "6-05", "forward stops when stop button pressed", 2, {0:false, 1:false, 2:true}, {0:true, 1:false}, {0:false}
            @simpleAdd "6-05", "reverse stops when stop button pressed", 2, {0:false, 1:false, 2:false}, {0:false, 1:true}, {1:false}
            @simpleAdd "6-05", "forward won't start if reverse is running", 1, {0:true, 1:true, 2:true}, {0:false, 1:true}, {0:false}

        add_11: ->
            @add_11a()
            @add_11b()

        add_11a: ->
        # 6-11a.rsl
        # SOR,0 XIC,I:1/3 BST,1 XIC,I:1/4 NXB,1 XIC,O:2/4 BND,1 OTE,O:2/4 EOR,0
        # SOR,1 XIC,O:2/2 XIC,I:1/3 XIO,I:1/4 XIO,O:2/4 BST,1 OTE,O:2/1 NXB,1 OTE,O:2/3 BND,1 EOR,1
        # SOR,2 XIC,O:2/2 BST,1 XIO,I:1/3 NXB,1 XIC,O:2/4 BND,1 OTE,O:2/0 EOR,2
        # SOR,3 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/2 BND,1 XIC,I:1/1 OTE,O:2/2 EOR,3

            @add_11_base "a"
        
        add_11b: ->
        # 6-11b.rsl
        # SOR,0 BST,1 XIC,I:1/3 BST,2 XIC,I:1/4 NXB,2 XIC,O:2/4 BND,2 NXB,1 XIC,I:1/7 BND,1 OTE,O:2/4 EOR,0
        # SOR,1 XIC,O:2/2 XIC,I:1/3 XIO,I:1/4 XIO,O:2/4 XIC,I:1/6 BST,1 OTE,O:2/1 NXB,1 OTE,O:2/3 BND,1 EOR,1
        # SOR,2 XIC,O:2/2 BST,1 XIO,I:1/3 NXB,1 XIC,O:2/4 BND,1 OTE,O:2/0 EOR,2
        # SOR,3 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/2 BND,1 XIC,I:1/1 XIO,I:1/5 OTE,O:2/2 EOR,3
            @add_11_base "b"
            @simpleAdd "6-11b", "conveyor turns off in mode A", 2, {0:false, 1:true, 3:false, 5:true}, {0:true, 2:false}, {0:false}
            @simpleAdd "6-11b", "solenoid turns off unless in mode B", 2, {0:false, 1:true, 3:true, 5:true, 6:false, 7:false}, {0:false, 1:true, 2:true}, {1:false}
            @simpleAdd "6-11b", "converyor runs in mode C", 1, {0:false, 1:true, 3:true, 7:true}, {0:true, 2:true}, {0:true}

        add_11_base: (letter)->
            @simpleAdd "6-11#{letter}", "converyor starts when start button pressed and no box on photo switch", 3, {0:true, 1:true, 3:false, 5:false}, {0:false, 1:false, 2:true, 3:false, 4:false}, {0:true}
            @simpleAdd "6-11#{letter}", "conveyor stops when stop button pressed", 1, {0:false, 1:false, 3:false, 5:false}, {0:true, 1:false, 2:false, 3:false, 4:false}, {0:false}
            @simpleAdd "6-11#{letter}", "conveyor stops when box on photo switch and not full", 3, {0:false, 1:true, 3:true, 4:false, 5:false}, {0:true, 1:false, 2:true, 3:false, 4:false}, {0:false}
            @simpleAdd "6-11#{letter}", "solenoid opens when box on photo switch and not full", 2, {0:false, 1:true, 3:true, 4:false, 5:false, 6:true, 7:false}, {0:false, 1:false, 2:true, 3:true, 4:false}, {1:true}
            @simpleAdd "6-11#{letter}", "solenoid closes when box is full", 2, {0:false, 1:true, 3:true, 4:true, 5:false, 6:true, 7:false}, {0:false, 1:true, 2:true, 3:true, 4:false}, {1:false}
            @simpleAdd "6-11#{letter}", "full light turns on when box full", 1, {0:false, 1:true, 3:true, 4:true, 5:false, 6:true, 7:false}, {0:false, 1:false, 2:true, 3:true, 4:false}, {4:true}
            @simpleAdd "6-11#{letter}", "fill/standby light turns on while filling", 1, {0:false, 1:true, 3:true, 4:false, 5:false, 6:true, 7:false}, {0:false, 1:true, 2:true, 3:false, 4:false}, {3:true}
            @simpleAdd "6-11#{letter}", "full light stays on until box is clear of photo switch", 1, {0:false, 1:true, 3:true, 4:false, 5:false, 6:true, 7:false}, {0:true, 1:false, 2:true, 3:false, 4:true}, {4:true}
            @simpleAdd "6-11#{letter}", "run light is on when the conveyor is running", 1, {0:true, 1:true, 3:false, 4:false, 5:false, 6:true, 7:false}, {0:true, 1:false, 2:false, 3:false, 4:false}, {2:true}

        add_12: ->
        # 6-12.rsl
        # SOR,0 XIC,I:1/0 XIO,I:1/1 XIO,I:1/2 OTE,O:2/0 EOR,0
            @simpleAdd "6-12", "Output turns on when I:1/0 on and both I:1/1 and I:1/2 off", 4, {0:true, 1:false, 2:false}, {0:false}, {0:true}

        add_14: ->
            @add_14a()
            @add_14b()

        add_14a: ->
        # 6-14a.rsl
        # SOR,0 XIC,I:1/0 OTL,O:2/0 EOR,0
        # SOR,1 XIC,I:1/1 OTU,O:2/0 EOR,1
            @add_14_base "a"
            @simpleAdd "6-14a", "output turns off if both I:1/0 and I:1/1 on", 2, {0:true, 1:true}, {0:true}, {0:false}

        add_14b: ->
        # 6-14b.rsl
        # SOR,0 XIC,I:1/1 OTU,O:2/0 EOR,0
        # SOR,1 XIC,I:1/0 OTL,O:2/0 EOR,1
            @add_14_base "b"
            @simpleAdd "6-14b", "output turns on if both I:1/0 and I:1/1 on", 2, {0:true, 1:true}, {0:false}, {0:true}

        add_14_base: (letter)->
            @simpleAdd "6-14#{letter}", "output turns on when I:1/0 on and I:1/1 off", 1, {0:true, 1:false}, {0:false}, {0:true}
            @simpleAdd "6-14#{letter}", "output turns off when I:1/0 off and I:1/1 on", 1, {0:false, 1:true}, {0:true}, {0:false}

        add_15: ->
        # 6-15.rsl
        # SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/0 BND,1 XIC,I:1/1 OTE,O:2/0 EOR,0
        # SOR,1 XIC,I:1/2 OTL,O:2/1 EOR,1
        # SOR,2 XIO,I:1/3 OTU,O:2/1 EOR,2
            @simpleAdd "6-15", "output O:2/0 starts when I:1/0 and I:1/1 on", 2, {0:true, 1:true}, {0:false}, {0:true} 
            @simpleAdd "6-15", "output O:2/0 stops when I:1/1 off", 2, {0:false, 1:false}, {0:true}, {0:false}
            @addTest "6-15", "output O:2/1 latches on when I:1/2 and I:1/3 on", 2, {I: {1: {2:true, 3:true}}, O: {2: {0:false}}}, {O: {2: {1:true}}, latch: [{file: "O", rank:2, bit:1}]}
            @addTest "6-15", "output O:2/1 unlatches when I:1/3 off", 2, {I: {1: {2:true, 3:false}}, O: {2: {1:true}}, latch:[{file: "O", rank:2, bit:1}]}, {O: {2: {1: false}}, latch: [] }

        add_20: ->
        # 6-20.rsl
        # SOR,0 BST,1 XIC,I:1/0 BST,2 XIC,I:1/1 NXB,2 BST,3 XIC,I:1/2 NXB,3 XIC,I:1/3 BND,3 BND,2 NXB,1 BST,2 XIC,I:1/1 BST,3 XIC,I:1/2 NXB,3 XIC,I:1/3 BND,3 NXB,2 XIC,I:1/2 XIC,I:1/3 BND,2 BND,1 OTE,O:2/0 EOR,0
        # SOR,1 BST,1 XIC,I:1/0 BST,2 XIC,I:1/1 XIC,I:1/2 NXB,2 BST,3 XIC,I:1/1 XIC,I:1/3 NXB,3 XIC,I:1/2 XIC,I:1/3 BND,3 BND,2 NXB,1 XIC,I:1/1 XIC,I:1/2 XIC,I:1/3 BND,1 OTE,O:2/1 EOR,1
        # SOR,2 XIC,I:1/0 XIC,I:1/1 XIC,I:1/2 XIC,I:1/3 OTE,O:2/2 EOR,2

            for pair in [[0, 1], [0,2], [0,3], [1,2], [1,3], [2,3]]
                inputObject = {}
                inputObject[pair[0]] = true
                inputObject[pair[1]] = true
                @simpleAdd "6-20", "output O:2/0 (green light) on when I:1/#{pair[0]} and I:1/#{pair[1]} on", 1, inputObject, {0:false}, {0:true}

            for three in [[0, 1, 2], [0, 2, 3], [0, 1, 3], [1, 2, 3]]
                inputObject = {}
                inputObject[three[0]] = true
                inputObject[three[1]] = true
                inputObject[three[2]] = true
                @simpleAdd "6-20", "output O:2/1 (yellow light) on when I:1/#{three[0]} and I:1/#{three[1]} and I:1/#{three[2]} on", 2, inputObject, {1:false}, {1:true}

            @simpleAdd "6-20", "output O:2/2 (red light) on when all inputs on", 6, {0:true, 1:true, 2:true, 3:true}, {2:false}, {2:true}

        add_21: ->
            @add_21a()
            @add_21b()

        add_21a: ->
        # 6-21a.rsl
        # SOR,0 XIC,I:1/0 XIO,B3:0/10 XIC,B3:0/11 OTE,B3:0/12 EOR,0
        # SOR,1 BST,1 XIC,I:1/0 XIO,B3:0/10 NXB,1 XIC,B3:0/11 BND,1 XIO,B3:0/12 OTE,B3:0/11 EOR,1
        # SOR,2 XIC,I:1/0 OTE,B3:0/10 EOR,2
        # SOR,3 XIC,B3:0/11 OTE,O:2/0 EOR,3

            @add_21_base "a"

        add_21b: ->
        # 6-21b.rsl
        # SOR,0 BST,1 XIC,I:1/0 NXB,1 BST,2 XIC,I:1/1 NXB,2 BST,3 XIO,I:1/2 NXB,3 XIO,I:1/3 BND,3 BND,2 BND,1 XIO,B3:0/10 XIC,B3:0/11 OTE,B3:0/12 EOR,0
        # SOR,1 BST,1 BST,2 XIC,I:1/0 NXB,2 BST,3 XIC,I:1/1 NXB,3 BST,4 XIO,I:1/2 NXB,4 XIO,I:1/3 BND,4 BND,3 BND,2 XIO,B3:0/10 NXB,1 XIC,B3:0/11 BND,1 XIO,B3:0/12 OTE,B3:0/11 EOR,1
        # SOR,2 BST,1 XIC,I:1/0 NXB,1 BST,2 XIC,I:1/1 NXB,2 BST,3 XIO,I:1/2 NXB,3 XIO,I:1/3 BND,3 BND,2 BND,1 OTE,B3:0/10 EOR,2
        # SOR,3 XIC,B3:0/11 OTE,O:2/0 EOR,3

            @add_21_base "b"
            @addTest "6-21b", "output goes from off to on when switch I:1/1 changes from off to on", 2, {I: {1: {1:true}}, B3: {0: {10:false}}, O: {2: {0:false}}}, {O: {2: {0:true}}, B3: {0: {10: true}}}
            @addTest "6-21b", "output goes remains on if switch I:1/2 held on", 2, {I: {1: {2:true}}, B3: {0: {10:true}}, O: {2: {0:true}}}, {O: {2: {0:true}}, B3: {0: {10:true}}}
            @addTest "6-21b", "output goes from on to off when switch I:1/3 changes from on to off", 2, {I: {1: {0:false}}, B3: {0: {10:false, 11:true}}, O: {2: {0:false}}}, {O: {2: {0:true}}, B3: {0: {10: true}}}
            @addTest "6-21b", "output goes remains off if switch I:1/1 held on", 1, {I: {1: {1:true}}, B3: {0: {10:true, 11:true}}, O: {2: {0:false}}}, {O: {2: {0:false}}, B3: {0: {10:true}}}

        add_21_base: (letter)->
            @addTest "6-21#{letter}", "output goes from off to on when switch changes from off to on", 4, {I: {1: {0:true}}, B3: {0: {10:false}}, O: {2: {0:false}}}, {O: {2: {0:true}}, B3: {0: {10: true}}}
            @addTest "6-21#{letter}", "output goes remains on if switch held on", 3, {I: {1: {0:true}}, B3: {0: {10:true}}, O: {2: {0:true}}}, {O: {2: {0:true}}, B3: {0: {10:true}}}
            @addTest "6-21#{letter}", "output goes from on to off when switch changes from off to on", 3, {I: {1: {0:true}}, B3: {0: {10:false, 11:true}}, O: {2: {0:false}}}, {O: {2: {0:true}}, B3: {0: {10: true}}}
            @addTest "6-21#{letter}", "output goes remains off if switch held on", 3, {I: {1: {0:true}}, B3: {0: {10:true, 11:true}}, O: {2: {0:false}}}, {O: {2: {0:false}}, B3: {0: {10:true}}}

        add_23: ->
        # 6-23.rsl
        # SOR,0 XIC,I:3/4 XIC,I:3/5 XIC,I:3/6 OTE,O:4/0 EOR,0

            @addTest "6-23", "output on when all three inputs on", 2, {I: {3: {4:true, 5:true, 6:true}}, O: {4: {0:false}}}, {O: {4: {0:true}}}
            @addTest "6-23", "output off unless all three inputs on", 2, {I: {3: {4:false, 5:true, 6:false}}, O: {4: {0:true}}}, {O: {4: {0:false}}}

        add_24: ->
        # 6-24.rsl
        # SOR,0 XIO,I:1/0 XIO,I:1/3 XIC,I:1/4 OTE,O:2/0 EOR,0
        # SOR,1 XIO,I:1/1 XIO,I:1/3 XIC,I:1/4 OTE,O:2/1 EOR,1
        # SOR,2 XIO,I:1/2 XIO,I:1/3 XIC,I:1/4 OTE,O:2/2 EOR,2

            @simpleAdd "6-24", "all outputs off if master switch off", 3, {4:false}, {0:true, 1:true, 2:true}, {0:false, 1:false, 2:false}
            @simpleAdd "6-24", "all outputs off if 80 degree sensor is on", 3, {3:true}, {0:true, 1:true, 2:true}, {0:false, 1:false, 2:false}
            @simpleAdd "6-24", "heater 1 off if 50 degree sensor is on", 3, {0:true}, {0:true}, {0:false}
            @simpleAdd "6-24", "heater 2 off if 60 degree sensor is on", 3, {1:true}, {1:true}, {1:false}
            @simpleAdd "6-24", "heater 3 off if 70 degree sensor is on", 3, {2:true}, {2:true}, {2:false}

        add_25: ->
        # 6-25.rsl
        # SOR,0 XIC,I:1/0 BST,1 XIC,I:1/1 NXB,1 XIC,O:2/0 BND,1 XIO,I:1/3 OTE,O:2/0 EOR,0
        # SOR,1 XIC,O:2/0 XIO,I:1/2 XIO,I:1/3 OTE,O:2/1 EOR,1
        # SOR,2 XIC,O:2/0 XIC I:1/2 XIO,I:1/3 OTE,O:2/2 EOR,2
        # SOR,3 XIC,I:1/2 OTE,O:2/3 EOR,3
        # SOR,4 XIC,I:1/3 OTE,O:2/4 EOR,4

            @simpleAdd "6-25", "pump starts when start button pressed", 3, {0:true, 1:true, 3:false}, {0:false}, {0:true}
            @simpleAdd "6-25", "pump stops when stop button pressed", 3, {0:false, 1:false, 3:false}, {0:true}, {0:false}
            @simpleAdd "6-25", "solenoid 1 is open when tank 1 is not full", 2, {0:true, 1:false, 2:false}, {0:true}, {0:true, 1:true}
            @simpleAdd "6-25", "solenoid 2 is open when tank 1 is full", 2, {0:true, 1:false, 2:true, 3:false}, {0:true, 1:true, 2:false}, {0:true, 1:false, 2:true}
            @simpleAdd "6-25", "pump stops when tank 2 is full", 3, {0:true, 1:false, 2:true, 3:true}, {0:true, 3:true, 4:true}, {0:false}
            @simpleAdd "6-25", "tank 1 full light on when tank 1 is full", 2, {2:true}, {3:false}, {3:true}
            @simpleAdd "6-25", "tank 2 full light on when tank 2 is full", 2, {3:true}, {4:false}, {4:true}

        add_27: ->
        # 6-27.rsl
        # SOR,0 XIC,I:1/0 BST,1 XIC,I:1/1 NXB,1 XIC,O:2/0 BND,1 XIO,I:1/2 XIO,O:2/1 BST,1 OTE,O:2/0 NXB,1 OTE,O:2/2 BND,1 EOR,0
        # SOR,1 XIC,I:1/0 BST,1 XIC,I:1/2 NXB,1 XIC,O:2/1 BND,1 XIO,I:1/1 XIO,O:2/0 BST,1 OTE,O:2/1 NXB,1 OTE,O:2/3 BND,1 EOR,1

            @addOrTest "6-27", "forward starts when fwd button pressed", 4, [{I: {1:{0:true, 1:true, 2:false}}, O: {2: {0:false, 1:false}}}, {I: {1:{0:true, 1:true, 2:false, 3:true}}, O: {2: {0:false, 1:false}}}], [{O: {2: {0:true, 1:false}}},{O: {2: {0:true, 1:false}}}]
            @addOrTest "6-27", "reverse starts when rev button pressed", 4, [{I: {1: {0:true, 1:false, 2:true}}, O: { 2: {0:false, 1:false}}}, {I: {1: {0:true, 1:false, 2:true, 3:true}}, O: { 2: {0:false, 1:false}}}], [{O: {2:{0:false, 1:true}}}, {O: {2:{0:false, 1:true}}}]
            @addOrTest "6-27", "stop button stops everything", 8, [{I: {1: {0:false}}, O: {2: {0:true, 1:true}}}, {I: {1: {0:false, 3:true}}, O: {2: {0:true, 1:true}}}], [{O: {2: {0:false, 1:false}}}, {O: {2: {0:false, 1:false}}}]

        add_28: ->
        # 6-28.rsl
        # SOR,0 XIO,I:1/0 XIC,I:1/2 BST,1 XIC,I:1/1 NXB,1 XIC,O:2/0 BND,1 XIO,I:1/5 OTE,O:2/0 EOR,0
        # SOR,1 XIO,I:1/0 XIC,I:1/4 BST,1 XIC,I:1/3 NXB,1 XIC,O:2/1 BND,1 XIO,I:1/6 OTE,O:2/1 EOR,1

            @simpleAdd "6-28", "output O:2/0 turns on if start button pressed, master stop is off, and overload is off", 4, {0:false, 1:true, 2:true, 5:false}, {0:false}, {0:true}
            @simpleAdd "6-28", "outputs can be stopped by master stop", 3, {0:true}, {0:true, 1:true}, {0:false, 1:false}
            @simpleAdd "6-28", "output O:2/1 turns on if start button pressed, master stop is off, and overload is off", 4, {0:false, 3:true, 4:true, 6:false}, {1:false}, {1:true}
            @simpleAdd "6-28", "output can be stopped by overload on", 3, {5:true, 6:true}, {0:true, 1:true}, {0:false, 1:false}

        add_29: ->
        # 6-29.rsl
        # SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,I:1/1 BND,1 OTE,O:2/0 EOR,0
        # SOR,1 XIC,I:1/2 BST,1 XIC,I:1/0 XIC,I:1/1 NXB,1 XIC,O:2/1 BND,1 OTE,O:2/1 EOR,1
        
            @simpleAdd "6-29", "output O:2/0 turns on if I:1/0 pressed", 2, {0:true}, {0:false}, {0:true}
            @simpleAdd "6-29", "output O:2/0 turns on if I:1/1 pressed", 2, {1:true}, {0:false}, {0:true}
            @simpleAdd "6-29", "alarm turns on if both buttons pressed and reset button not pressed", 2, {0:true, 1:true, 2:true}, {1:false}, {1:true}
            @simpleAdd "6-29", "alarm stays on if reset button not pressed", 2, {0:false, 1:false, 2:true}, {1:true}, {1:true}
            @simpleAdd "6-29", "alarm turns off if reset button pressed", 2, {0:false, 1:false, 2:false}, {1:true}, {1:false}

        add_30: ->
        # 6-30.rsl
        # SOR,0 XIC,I:1/2 BST,1 XIC,I:1/0 NXB,1 XIC,B3:0/0 BND,1 OTE,B3:0/0 EOR,0
        # SOR,1 XIC,I:1/2 BST,1 XIC,I:1/1 NXB,1 XIC,B3:0/1 BND,1 OTE,B3:0/1 EOR,1
        # SOR,2 XIC,I:1/2 BST,1 XIC,B3:0/0 XIO,B3:0/1 NXB,1 XIC,B3:0/2 BND,1 OTE,B3:0/2 EOR,2
        # SOR,3 XIC,I:1/2 BST,1 XIC,B3:0/1 XIO,B3:0/0 NXB,1 XIC,B3:0/3 BND,1 OTE,B3:0/3 EOR,3
        # SOR,4 XIC,I:1/2 XIC,B3:0/2 XIC,B3:0/1 OTE,O:2/0 EOR,4
        # SOR,5 XIC,I:1/2 XIC,B3:0/3 OTE,O:2/1 EOR,5

            @addTest "6-30", "green light turns on if buttons pressed in order", 13, @runThroughTwice("6-30", {0:true, 1:false, 2:true},{0:false,1:true,2:true}), {O: {2: {0:true}}}
            @simpleAdd "6-30", "red light turns on if red button pressed first", 12, {0:false, 1:true, 2:true}, {1:false}, {1:true}

        add_31: ->
        # 6-31.rsl
        # SOR,0 XIC,I:1/2 BST,1 XIC,I:1/0 XIO,I:1/1 XIO,O:2/1 NXB,1 XIC,O:2/0 BND,1 XIC,I:1/3 OTE,O:2/0 EOR,0
        # SOR,1 XIC,I:1/2 BST,1 XIC,I:1/1 XIO,I:1/0 XIO,O:2/0 NXB,1 XIC,O:2/1 BND,1 XIO,I:1/4 OTE,O:2/1 EOR,1
        # SOR,2 XIC,I:1/3 XIO,I:1/4 OTE,O:2/2 EOR,2
        # SOR,3 XIO,I:1/3 OTE,O:2/3 EOR,3
        # SOR,4 XIC,I:1/4 OTE,O:2/4 EOR,4

            @simpleAdd "6-31", "garage door starts going up if up pressed and door not all the way up", 4, {0:true, 1:false, 2:true, 3:true}, {0:false, 1:false}, {0:true}
            @simpleAdd "6-31", "garage door starts going down if down pressed and door not all the way down", 4, {0:false, 1:true, 2:true, 3:true, 4:false}, {0:false, 1:false}, {1:true}
            @simpleAdd "6-31", "down button does nothing if door is moving up", 4, {0:false, 1:true, 2:true, 3:true}, {0:true, 1:false}, {0:true, 1:false}
            @simpleAdd "6-31", "up button does nothing if door is moving down", 4, {0:true, 1:false, 2:true, 3:true, 4:false}, {1:true, 0:false}, {1:true, 0:false}
            @simpleAdd "6-31", "stop button stops the door", 1, {0:false, 1:false, 2:false, 3:true, 4:false}, {0:false, 1:true}, {0:false, 1:false}
            @simpleAdd "6-31", "open light is on when door all the way up", 2, {0:false, 1:false, 3:false, 4:false}, {0:false, 1:false, 3:false}, {3:true}
            @simpleAdd "6-31", "closed light is on when door all the way down", 1, {0:false, 1:false, 3:true, 4:true}, {0:false, 1:false, 4:false}, {4:true}
            @simpleAdd "6-31", "ajar light is on when door in between", 1, {0:false, 1:false, 3:true, 4:false}, {0:false, 1:false, 2:false}, {2:true}


        add_34: ->
        # 6-34.rsl
        # SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,O:2/0 BND,1 XIC,I:1/1 OTE,O:2/0 EOR,0
        # SOR,1 XIC,I:1/2 XIC,O:2/0 OTE,O:2/1 EOR,1
        # SOR,2 XIC,I:1/3 XIC,O:2/1 OTE,O:2/2 EOR,2
        # SOR,3 XIO,I:1/3 XIC,I:1/4 XIO,O:2/1 BST,1 OTE,O:2/3 NXB,1 OTE,O:2/4 BND,1 EOR,3

            @simpleAdd "6-34", "O:2/0 turns on when I:1/0 is on", 3, {0:true, 1:true}, {0:false}, {0:true}
            @simpleAdd "6-34", "O:2/0 turns off when I:1/1 is off", 2, {0:false, 1:false}, {0:true}, {0:false}
            @simpleAdd "6-34", "O:2/1 turns on when O:2/0 on and I:1/2 on", 3, {0:false, 1:true, 2:true}, {0:true}, {1:true}

            @addOrTest "6-34", "O:2/2 turns on when O:2/1 on", 3, [{I: {1: {0:false, 1:true, 2:true, 3:true}}, O:{2: {0:true, 1:true}}}, {I: {1: {0:false, 1:true, 2:true, 3:false}}, O:{2: {0:true, 1:true}}}], [{O:{2: {2:true}}},{O:{2:{2:true}}}]
            @addOrTest "6-34", "O:2/3 and O:2/4 turn on when O:2/1 off and I:1/4 on", 4, [{I: {1:{0:false, 1:false, 2:false, 3:false, 4:true}}}, {I: {1:{0:false, 1:false, 2:false, 3:true, 4:true}}}], [{O: {2:{3:true, 4:true}}},{O: {2:{3:true, 4:true}}}]

        
    module.exports = Grader_ch6
).call this
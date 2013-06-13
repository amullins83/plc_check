(->
    "use strict"
    RSLParser = require "../models/RSLParser.coffee"
    DataTable = require "../models/dataTable.coffee"
    fs = require "fs"
    Grader = require "./grader.coffee"
    Find = require "../models/find.coffee"

    class Grader_ch5 extends Grader
        constructor: (@folderPath)->
            super @folderPath
            @initializeProblems()
            @run()

        initializeProblems: ->
            super()
            @add_02()
            @add_03()
            @add_04()
            @add_05()
            @add_06()
            @add_07()
            @add_08()
            @add_09()
            @add_10()
            @add_11()
            @add_12()
            @add_13()
            @add_14()

        add_02: ->
        #SOR,0 BST,1 XIC,I:1/0 XIC,I:1/1 NXB,1 BST,2 XIC,I:1/2 NXB,2 XIC,I:1/4 BND,2 XIC,I:1/3 BND,1 OTE,O:2/0 EOR,0
            @simpleAdd "5-02", "O:2/0 turns on when A and B on", 2, {0:true, 1:true}, {}, {0:true}
            @simpleAdd "5-02", "O:2/0 turns on when C and D on", 1, {2:true, 3:true}, {}, {0:true}
            @simpleAdd "5-02", "O:2/0 turns on when E and D on", 1, {3:true, 4:true}, {}, {0:true}
            @simpleAdd "5-02", "O:2/0 turns off when A and D off", 1, {1:true, 2:true, 4:true}, {0:true}, {0:false}
            
        
        add_03: ->
        #SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,I:1/2 BST,2 XIC,I:1/1 NXB,2 XIC,I:1/3 BND,2 BND,1 OTE,O:2/0 EOR,0
            @simpleAdd "5-03", "O:2/0 turns on when A on", 1, {0:true}, {}, {0:true}
            @simpleAdd "5-03", "O:2/0 turns on when C and B on", 1, {1:true, 2:true}, {}, {0:true}
            @simpleAdd "5-03", "O:2/0 turns on when C and D on", 1, {2:true, 3:true}, {}, {0:true}
            @simpleAdd "5-03", "O:2/0 turns off when A and C off", 2, {1:true, 3:true}, {0:true}, {0:false}
            
        
        add_04: ->
        #SOR,0 BST,1 XIC,I:1/0 XIC,I:1/1 NXB,1 BST,2 XIC,I:1/0 XIC,I:1/2 XIC,I:1/3 NXB,2 BST,3 XIC,I:1/4 XIC,I:1/3 NXB,3 XIC,I:1/4 XIC,I:1/2 XIC,I:1/1 BND,3 BND,2 BND,1 OTE,O:2/0 EOR,0
            @simpleAdd "5-04", "O:2/0 turns on when A and B on", 1, {0:true, 1:true}, {}, {0:true}
            @simpleAdd "5-04", "O:2/0 turns on when A, C, and D on", 1, {0:true, 2:true, 3:true}, {}, {0:true}
            @simpleAdd "5-04", "O:2/0 turns on when E and D on", 1, {3:true, 4:true}, {}, {0:true}
            @simpleAdd "5-04", "O:2/0 turns on when E, C, and B on", 1, {1:true, 2:true, 4:true}, {}, {0:true}
            @simpleAdd "5-04", "O:2/0 turns off when A and E off", 2, {1:true, 2:true, 3:true}, {0:true}, {0:false}
            @simpleAdd "5-04", "O:2/0 turns off when B and D off", 2, {0:true, 2:true, 4:true}, {0:true}, {0:false}
            
        
        add_05: ->
            @add_05a()
            @add_05b()

        add_05a: ->
        #SOR,0 XIC,I:1/0 OTE,O:2/0 EOR,0
        #SOR,1 XIO,I:1/0 OTE,O:2/1 EOR,1
            @simpleAdd "5-05a", "O:2/0 turns on when I:1/0 is on", 2, {0:true}, {}, {0:true}
            @simpleAdd "5-05a", "O:2/1 turns on when I:1/0 is off", 1, {0:false}, {}, {1:true}
            @simpleAdd "5-05a", "O:2/0 turns off when I:1/0 is off", 1, {0:false}, {0:true}, {0:false}
            @simpleAdd "5-05a", "O:2/1 turns off when I:1/0 is on", 1, {0:true}, {1:true}, {1:false}
        
        add_05b: ->
        #SOR,0 XIO,I:1/1 OTE,O:2/0 EOR,0
        #SOR,1 XIC,I:1/1 OTE,O:2/1 EOR,1
            @simpleAdd "5-05b", "O:2/0 turns on when I:1/1 is off", 2, {1:false}, {}, {0:true}
            @simpleAdd "5-05b", "O:2/1 turns on when I:1/1 is on", 1, {1:true}, {}, {1:true}
            @simpleAdd "5-05b", "O:2/0 turns off when I:1/1 is on", 1, {1:true}, {0:true}, {0:false}
            @simpleAdd "5-05b", "O:2/1 turns off when I:1/1 is off", 1, {1:false}, {1:true}, {1:false}
            
        
        add_06: ->        
        # SOR,0 BST,1 XIC,I:1/2 NXB,1 XIC,O:2/0 BND,1 XIC,I:1/0 OTE,O:2/0 EOR,0
        # SOR,1 XIC,I:1/1 XIO,O:2/0 XIC,I:1/6 OTE,O:2/1 EOR,1
        # SOR,2 XIC,I:1/7 XIC,I:1/4 XIC,O:2/1 OTE,O:2/2 EOR,2
        # SOR,3 BST,1 XIC,I:1/3 NXB,1 XIC,O:2/3 BND,1 XIC,I:1/5 XIO,O:2/1 BST,1 OTE,O:2/3 NXB,1 OTE,O:2/4 BND,1 EOR,3
            @simpleAdd "5-06", "O:2/0 turns on when I:1/2 and I:1/0 are on", 2, {0:true, 2:true}, {}, {0:true}
            @simpleAdd "5-06", "O:2/0 stays on when I:1/0 is on", 1, {0:true}, {0:true}, {0:true}
            @simpleAdd "5-06", "O:2/0 turns off when I:1/0 is off", 1, {2:true}, {0:true}, {0:false}
            @simpleAdd "5-06", "O:2/1 is on when I:1/1 and I:1/6 are on and O:2/0 is off", 1, {1:true, 6:true}, {0:false}, {1:true}
            @simpleAdd "5-06", "O:2/1 is off when O:2/0 is on", 1, {0:true, 1:true, 6:true}, {0:true, 1:true}, {1:false}
            @simpleAdd "5-06", "O:2/2 is on when I:1/7, I:1/4, and O:2/1 are on", 1, {1:true, 4:true, 6:true, 7:true}, {1:true}, {2:true}
            @simpleAdd "5-06", "O:2/3 and O:2/4 are on when I:1/3 and I:1/5 are on and O:2/1 is off", 1, {0:true, 2:true, 3:true, 5:true}, {0:true}, {3:true, 4:true}
            @simpleAdd "5-06", "O:2/3 and O:2/4 stay on when I:1/3 turns off", 2, {0:true, 2:true, 3:false, 5:true}, {0:true, 3:true, 4:true}, {3:true, 4:true}

        add_07: ->
        # SOR,0 XIO,I:1/0 OTE,O:2/0 EOR,0
        # SOR,1 XIC,I:1/3 OTE,O:2/1 EOR,1
        # SOR,2 XIC,I:1/4 OTE,O:2/2 EOR,2
        # SOR,3 XIC,I:1/5 OTE,O:2/3 EOR,3
            @simpleAdd "5-07", "I'll accept any attempt on this one.", 5, {}, {}, {}

        add_08: ->
        # SOR,0 XIC,I:1/0 BST,1 OTE,O:2/0 NXB,1 OTE,O:2/1 BND,1 EOR,0
        # SOR,1 XIC,I:1/0 BST,1 XIO,I:1/1 NXB,1 XIO,I:1/2 BND,1 OTE,O:2/2 EOR,1
        # SOR,2 OTE,O:2/3 EOR,2
        # SOR,3 XIC,I:1/3 OTE,O:2/4 EOR,3
        # SOR,4 XIO,I:1/3 OTE,O:2/5 EOR,4
            @simpleAdd "5-08", "O:2/0 and O:2/1 turn on when I:1/0 is on", 1, {0:true}, {}, {0:true, 1:true}
            @simpleAdd "5-08", "O:2/0 and O:2/1 turn off when I:1/0 is off", 1, {}, {0:true, 1:true}, {0:false, 1:false}
            @simpleAdd "5-08", "O:2/2 turns on when I:1/0 on and I:1/1 off", 1, {0:true, 2:true}, {}, {2:true}
            @simpleAdd "5-08", "O:2/2 turns on when I:1/0 on and I:1/2 off", 1, {0:true, 1:true}, {}, {2:true}
            @simpleAdd "5-08", "O:2/3 is on when I:1/3 is on", 1, {3:true}, {}, {3:true}
            @simpleAdd "5-08", "O:2/3 is on when I:1/3 is off", 1, {}, {}, {3:true}
            @simpleAdd "5-08", "O:2/4 is on when I:1/3 is on", 1, {3:true}, {}, {4:true}
            @simpleAdd "5-08", "O:2/5 is on when I:1/3 is off", 1, {}, {}, {5:true}
            

        add_09: ->
        # SOR,0 XIC,I:1/0 BST,1 XIC,I:1/1 XIC,I:1/2 NXB,1 BST,2 XIC,I:1/3 XIC,I:1/2 NXB,2 XIC,I:1/4 BND,2 BND,1 OTE,O:2/0 EOR,0
            @simpleAdd "5-09", "O:2/0 turns on when I:1/0, 1, and 2 are all on", 2, {0:true, 1:true, 2:true}, {}, {0:true}
            @simpleAdd "5-09", "O:2/0 turns on when I:1/0, 2, and 3 are all on", 2, {0:true, 2:true, 3:true}, {}, {0:true}
            @simpleAdd "5-09", "O:2/0 turns on when I:1/0 and I:1/4 are on", 1, {0:true, 4:true}, {}, {0:true}
            @simpleAdd "5-09", "O:2/0 turns off when I:1/0 is off", 1, {4:true}, {0:true}, {0:false} 
            

        add_10: ->
        #SOR,0 BST,1 XIC,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/3 BND,1 XIC,I:1/2 OTE,O:2/0 EOR,0
            @simpleAdd "5-10", "O:2/0 turns on when I:1/0, 1, and 2 are all on", 3, {0:true, 1:true, 2:true}, {}, {0:true}
            @simpleAdd "5-10", "O:2/0 turns on when I:1/2 and I:1/3 are on", 1, {2:true, 3:true}, {}, {0:true}
            @simpleAdd "5-10", "O:2/0 turns off when I:1/0 and I:1/3 are off", 1, {1:true, 2:true}, {0:true}, {0:false}
            

        add_11: ->
        #SOR,0 BST,1 XIC,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/2 BND,1 XIO,I:1/3 OTE,O:2/0 EOR,0
            @simpleAdd "5-11", "O:2/0 turns on when I:1/0 and I:1/1 are on", 1, {0:true, 1:true}, {}, {0:true}
            @simpleAdd "5-11", "O:2/0 turns on when I:1/2 is on", 1, {2:true}, {}, {0:true}
            @simpleAdd "5-11", "O:2/0 turns off when I:1/3 is on", 1, {2:true, 3:true}, {0:true}, {0:false}
            @simpleAdd "5-11", "O:2/0 turns off when I:1/0 and I:1/2 are off", 1, {}, {0:true}, {0:false}
            

        add_12: ->
            @add_12a()
            @add_12b()

        add_12a: ->
        #SOR,0 XIO,I:1/0 BST,1 XIC,I:1/1 NXB,1 XIC,O:2/0 BND,1 OTE,O:2/0 EOR,0
            @simpleAdd "5-12a", "O:2/0 turns on when I:1/1 pressed and I:1/0 open", 1, {1:true}, {}, {0:true}
            @simpleAdd "5-12a", "O:2/0 stays on when started", 1, {}, {0:true}, {0:true}
            @simpleAdd "5-12a", "O:2/0 turns off when I:1/0 closed", 2, {0:true, 1:true}, {0:true}, {0:false}

        add_12b: ->
        #SOR,0 XIC,I:1/0 BST,1 XIC,I:1/1 NXB,1 XIC,O:2/0 BND,1 OTE,O:2/0 EOR,0
            @simpleAdd "5-12b", "O:2/0 turns on when I:1/1 pressed and I:1/0 closed", 1, {0:true, 1:true}, {}, {0:true}
            @simpleAdd "5-12b", "O:2/0 stays on when started", 1, {0:true}, {0:true}, {0:true}
            @simpleAdd "5-12b", "O:2/0 stops when I:1/0 opened", 2, {1:true}, {0:true}, {0:false}

        add_13: ->
        # SOR,0 XIC,I:1/0 OTE,O:2/0 EOR,0
        # SOR,1 XIC,I:1/1 OTE,O:2/1 EOR,1
        # SOR,2 XIC,O:2/0 XIO,O:2/1 OTE,O:2/2 EOR,2
        # SOR,3 XIO,O:2/0 XIC,O:2/1 OTE,O:2/3 EOR,3
        # SOR,4 XIC,O:2/0 XIC,O:2/1 OTE,O:2/4 EOR,4
            @simpleAdd "5-13", "O:2/0 is on when I:1/0 is on", 1, {0:true}, {}, {0:true}
            @simpleAdd "5-13", "O:2/1 is on when I:1/1 is on", 1, {1:true}, {}, {1:true}
            @simpleAdd "5-13", "O:2/2 is on when O:2/0 is on and O:2/1 is off", 1, {0:true}, {}, {2:true}
            @simpleAdd "5-13", "O:2/3 is on when O:2/0 is off and O:2/1 is on", 1, {1:true}, {}, {3:true}
            @simpleAdd "5-13", "O:2/4 is on when O:2/0 and O:2/1 are both on", 1, {0:true, 1:true}, {}, {4:true}
            
            @simpleAdd "5-13", "O:2/0 is off when I:1/0 is off", 1, {}, {0:true}, {0:false}
            @simpleAdd "5-13", "O:2/1 is off when I:1/1 is off", 1, {}, {1:true}, {1:false}
            @simpleAdd "5-13", "O:2/2 is off when O:2/1 is on", 1, {1:true}, {2:true}, {2:false}
            @simpleAdd "5-13", "O:2/3 is off when O:2/0 is on", 1, {0:true}, {3:true}, {3:false}
            @simpleAdd "5-13", "O:2/4 is off when O:2/0 or O:2/1 is off", 1, {0:true}, {4:true}, {4:false}

        add_14: ->
            @add_14a()
            @add_14b()

        add_14a: ->
        #SOR,0 BST,1 XIO,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/0 XIO,I:1/1 BND,1 OTE,O:2/0 EOR,0
            @add_14_base "a"

        add_14b: ->
        # SOR,0 BST,1 XIO,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/0 XIO,I:1/1 BND,1 OTE,B3:1/0 EOR,0
        # SOR,1 BST,1 XIO,I:1/2 XIC,B3:1/0 NXB,1 XIC,I:1/2 XIO,B3:1/0 BND,1 OTE,O:2/0 EOR,1
            @add_14_base "b"
            @simpleAdd "5-14b", "O:2/0 should turn on when S1 and S2 are off and S3 is on", 1, {2:true}, {}, {0:true}
            @simpleAdd "5-14b", "O:2/0 should turn on when S1 and S2 and S3 are on", 1, {0:true, 1:true, 2:true}, {}, {0:true}
            @simpleAdd "5-14b", "O:2/0 should turn off when S1 and S3 are on and S2 is off", 1, {0:true, 2:true}, {0:true}, {0:false}
            @simpleAdd "5-14b", "O:2/0 should turn off when S2 and S3 are on and S1 is off", 1, {1:true, 2:true}, {0:true}, {0:false}
            

        add_14_base: (letter)->
            @simpleAdd "5-14#{letter}", "O:2/0 should turn on when S1 is on and S2 is off", 1, {0:true}, {}, {0:true}
            @simpleAdd "5-14#{letter}", "O:2/0 should turn on when S2 is on and S1 is off", 1, {0:true}, {}, {0:true}
            @simpleAdd "5-14#{letter}", "O:2/0 should turn off when S1 and S2 are off", 1, {}, {0:true}, {0:false}
            @simpleAdd "5-14#{letter}", "O:2/0 should turn off when S1 and S2 are on", 1, {0:true, 1:true}, {0:true}, {0:false}

    module.exports = Grader_ch5
).call this
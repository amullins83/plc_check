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
            @simpleAdd "1-1a", "output O:2/0 is on when I:1/0 and I:1/1 are on", 2, {0:true, 1:true, 2:false}, {}, {0:true}
            @simpleAdd "1-1a", "output O:2/0 is on when I:1/2 is on", 1, {1:true, 2:true}, {}, {0:true}
            @simpleAdd "1-1a", "output O:2/0 is off otherwise", 1, {0:true}, {0:true}, {0:false}

        add_1_1_b_tests: ->
            @simpleAdd "1-1b", "output O:2/0 is on when I:1/0 and I:1/1 are on", 1, {0:true, 1:true}, {}, {0:true}
            @simpleAdd "1-1b", "output O:2/0 is on when I:1/2 and I:1/1 are on", 1,  {1:true, 2:true}, {}, {0:true}
            @simpleAdd "1-1b", "output O:2/0 is off otherwise", 2, {0:true, 2:true}, {0:true}, {0:false}

        add_1_1_c_tests: ->
            @simpleAdd "1-1c", "output O:2/0 is on when I:1/0, I:1/1, and I:1/2 are on", 1, {0:true,1:true,2:true}, {}, {0:true}
            @simpleAdd "1-1c", "output O:2/0 is off when I:1/0 is off", 1, {1:true, 2:true}, {0:true}, {0:false}
            @simpleAdd "1-1c", "output O:2/0 is off when I:1/1 is off", 1, {0:true, 2:true}, {0:true}, {0:false}
            @simpleAdd "1-1c", "output O:2/0 is off when I:1/2 is off", 1, {0:true, 1:true}, {0:true}, {0:false}

        add_1_1_d_tests: ->
            @simpleAdd "1-1d", "output O:2/0 is on when I:1/0 is on", 1, {0:true}, {}, {0:true}
            @simpleAdd "1-1d", "output O:2/0 is on when I:1/1 is on", 1, {1:true}, {}, {0:true}
            @simpleAdd "1-1d", "output O:2/0 is on when I:1/2 is on", 1, {2:true}, {}, {0:true}
            @simpleAdd "1-1d", "output O:2/0 is off when all inputs off", 1, {}, {0:true}, {0:false}

        add_1_2_tests: ->
            @simpleAdd "1-2", "output O:2/0 is on when I:1/0 and I:1/1 are on", 1, {0:true, 1:true}, {}, {0:true}
            @simpleAdd "1-2", "output O:2/0 is off when I:1/0 off", 1, {1:true}, {0:true}, {0:false}
            @simpleAdd "1-2", "output O:2/0 is off when I:1/1 off", 1, {0:true}, {0:true}, {0:false}

        add_1_3_tests: ->
            @simpleAdd "1-3", "output O:2/0 is off when I:1/0 and I:1/1 are both off", 1, {}, {0:true}, {0:false}
            @simpleAdd "1-3", "output O:2/0 is on when I:1/0 on", 1, {1:true}, {}, {0:true}
            @simpleAdd "1-3", "output O:2/0 is on when I:1/1 on", 1, {0:true}, {}, {0:true}            
            

        add_1_4_tests: ->
            @simpleAdd "1-4", "output O:2/0 is on when I:1/0 and I:1/1 are on", 1, {0:true, 1:true}, {}, {0:true}
            @simpleAdd "1-4", "output O:2/0 is on when I:1/2 and I:1/3 are on", 1, {2:true, 3:true}, {}, {0:true}
            @simpleAdd "1-4", "output O:2/0 is off unless either I:1/0 and I:1/1 or I:1/2 and I:1/3 are on", 1, {1:true, 3:true}, {0:true}, {0:false}

        add_1_5_tests: ->
            @simpleAdd "1-5", "output O:2/0 is on when I:1/0 and I:1/1 are on", 2, {0:true, 1:true}, {}, {0:true}
            @simpleAdd "1-5", "output O:2/0 is on when I:1/0 and I:1/2 are on", 2, {0:true, 2:true}, {}, {0:true}
            @simpleAdd "1-5", "output O:2/0 is off when I:1/0 off", 1, {1:true}, {0:true}, {0:false}

        add_1_6_tests: ->
            @simpleAdd "1-6", "output O:2/0 is on when all of inputs 0, 4, 5, and one of inputs 1, 2, and 3 is on", 4, {0:true, 1:true, 4:true, 5:true}, {}, {0:true}
            @simpleAdd "1-6", "output O:2/0 is off unless inputs 0, 4, 5 are all on and one of inputs 1, 2, and 3 is on", 3, {1:true, 4:true, 5:true}, {0:true}, {0:false}

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
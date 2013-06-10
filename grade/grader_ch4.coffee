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
        #SOR,0 XIC,I:1/0 XIC,I:1/1 BST,1 XIC,I:1/2 NXB,1 XIC,I:1/3 BND,1 XIO,I:1/4 OTE,O:2/0 EOR,0
            @simpleAdd "4-01", "O:2/0 turns on when I:1/0, 1, and 2 are on and I:1/4 is off", 2, {0:true, 1:true, 2:true, 4:false}, {0:false}, {0:true}
            @simpleAdd "4-01", "O:2/0 turns on when I:1/0, 1, and 3 are on and I:1/4 is off", 2, {0:true, 1:true, 3:true, 4:false}, {0:false}, {0:true}
            @simpleAdd "4-01", "O:2/0 turns off when I:1/4 is on", 2, {0:true, 1:true, 2:true, 3:true, 4:true}, {0:true}, {0:false}

        add_02: ->
        #SOR,0 XIO,I:1/0 BST,1 XIC,I:1/1 NXB,1 XIC,I:1/2 BND,1 XIC,I:1/3 XIC,I:1/4 BST,1 XIC,I:1/5 NXB,1 BST,2 XIC,I:1/6 NXB,2 XIC,I:1/7 BND,2 BND,1 OTE,O:2/0 EOR,0

        add_03: ->
        #SOR,0 XIC,I:1/0 XIC,I:1/1 OTE,O:2/0 EOR,0
            @simpleAdd "4-03", "O:2/0 turns on when I:1/0 and I:1/1 are both on", 1, {0:true, 1:true}, {0:false}, {0:true}
            @simpleAdd "4-03", "O:2/0 turns off when I:1/0 off", 1, {1:true}, {0:true}, {0:false}
            @simpleAdd "4-03", "O:2/0 turns off when I:1/1 off", 1, {0:true}, {0:true}, {0:false}

        add_04: ->
        #SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,I:1/1 BND,1 OTE,O:2/0 EOR,0
        
        add_05: ->
        #SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,I:1/1 BND,1 XIC,I:1/2 OTE,O:2/0 EOR,0

        add_06: ->        
        #SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,I:1/1 BND,1 BST,1 XIC,I:1/2 NXB,1 XIC,I:1/3 BND,1 OTE,O:2/0 EOR,0

        add_07: ->
        #SOR,0 BST,1 XIC,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/2 BND,1 OTE,O:2/0 EOR,0

        add_08: ->
        #SOR,0 BST,1 XIC,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/2 XIC,I:1/3 BND,1 OTE,O:2/0 EOR,0
        #
        add_09: ->
        #SOR,0 XIC,I:1/0 XIC,I:1/1 OTE,O:2/0 EOR,0

        add_10: ->
        #SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,I:1/1 BND,1 XIC,I:1/2 XIC,I:1/3 OTE,O:2/0 EOR,0

        add_11: ->
        #SOR,0 BST,1 XIC,I:1/0 XIO,I:1/1 XIC,I:1/2 NXB,1 BST,2 XIO,I:1/3 NXB,2 XIC,I:1/4 BND,2 BND,1 OTE,O:2/0 EOR,0

        add_12: ->
        #SOR,0 BST,1 BST,2 XIO,I:1/0 NXB,2 XIO,I:1/1 BND,2 XIC,I:1/2 NXB,1 XIC,I:1/3 XIC,I:1/4 BND,1 OTE,O:2/0 EOR,0

        add_13: ->
        #SOR,0 BST,1 XIO,I:1/0 XIC,I:1/1 XIO,I:1/2 NXB,1 XIC,I:1/3 XIO,I:1/4 XIC,I:1/5 BND,1 OTE,O:2/0 EOR,0

        add_14: ->
        #SOR,0 BST,1 XIO,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/0 XIO,I:1/1 BND,1 OTE,O:2/0 EOR,0

        add_15: ->
        #SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,I:1/1 BND,1 XIO,I:1/2 XIO,I:1/3 OTE,O:2/0 EOR,0

        add_16: ->
        #SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,I:1/1 BND,1 XIC,I:1/2 XIO,I:1/3 OTE,O:2/0 EOR,0

        add_17: ->
        #SOR,0 BST,1 XIO,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/0 XIO,I:1/1 BND,1 OTE,O:2/0 EOR,0

        add_18: ->
        #SOR,0 BST,1 XIC,I:1/0 NXB,1 BST,2 XIC,I:1/1 NXB,2 XIC,O:2/0 BND,2 BND,1 XIC,I:1/2 XIC,I:1/3 OTE,O:2/0 EOR,0

        add_19: ->
        #SOR,0 XIO,I:1/0 XIO,I:1/1 XIC,I:1/2 XIC,I:1/3 OTE,O:2/0 EOR,0

        add_20: ->
        #SOR,0 BST,1 XIC,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/2 BND,1 OTE,O:2/0 EOR,0

        add_21: ->
        #SOR,0 BST,1 XIC,I:1/0 NXB,1 XIC,I:1/1 BND,1 BST,1 XIC,I:1/2 NXB,1 XIC,I:1/3 BND,1 OTE,O:2/0 EOR,0

        add_22: ->
        #SOR,0 BST,1 XIC,I:1/0 XIC,I:1/1 NXB,1 XIC,I:1/2 BND,1 XIC,I:1/3 XIO,I:1/4 OTE,O:2/0 EOR,0

        add_23: ->
        #SOR,0 BST,1 XIC,I:1/0 XIO,I:1/1 NXB,1 BST,2 XIC,I:1/2 XIO,I:1/3 NXB,2 XIC,I:1/4 XIO,I:1/5 BND,2 BND,1 OTE,O:2/0 EOR,0

        add_24: ->
        #SOR,0 XIC,I:1/0 AND,B3:5,B3:7,B3:10 EOR,0
            @addTest "4-24", "B3:10 is the AND of B3:5 and B3:7 if I:1/0 is on", 4, {I: {1: {0:true}}, B3: {5: @fives(), 7: @threes()}}, {B3: {10: @and_array @fives(), @threes()}} 
            @addTest "4-24", "nothing happens if I:1/0 is off", 1, {I: {1: {0:false}}, B3: {5: @fives(), 7: @threes(), 10: @effs()}}, {B3: {10: @effs()}}

        add_25: ->
        #SOR,0 XIC,I:1/0 OR ,B3:1,B3:2,B3:20 EOR,0
            @addTest "4-25", "B3:20 is the OR of B3:1 and B3:2 if I:1/0 is on", 4, {I: {1: {0:true}}, B3: {1: @fives(), 2: @tens()}, 20: @zeros()}, {B3: {20: @effs()}} 
            @addTest "4-25", "nothing happens if I:1/0 is off", 1, {I: {1: {0:false}}, B3: {1: @fives(), 2: @tens(), 20: @zeros()}}, {B3: {20: @zeros()}}

        add_26: ->
        #SOR,0 XOR,I:1,I:3,O:4 EOR,0
            @addTest "4-26", "O:4 is the XOR of I:1 and I:3", 3, {I: {1: @fives(), 3: @threes()}, O: {4: @zeros()}}, {O: {4: @xor_array @fives(), @threes()}}
            @addTest "4-26", "the XOR block always runs", 1, {I: {1: @tens(), 3: @threes()}, O: {4: @zeros()}}, {O: {4: @xor_array @tens(), @threes()}} 

        add_27: ->
        #SOR,0 XIC,I:1/0 NOT,B3:9,B3:10 EOR,0
            @addTest "4-27", "B3:10 is the NOT of B3:9 if I:1/0 is on", 3, {I: {1: {0:true}}, B3: {9: @fives(), 10: @zeros()}}, {B3: {10: @tens()}} 
            @addTest "4-27", "nothing happens if I:1/0 is off", 1, {I: {1: {0:false}}, B3: {9: @fives(), 10: @effs()}}, {B3: {10: @effs()}}

        convert_binary_to_tf: (binary_array)->
            not not bit for bit in binary_array

        fives: ->
            @convert_binary_to_tf [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]

        tens: ->
            @convert_binary_to_tf [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]

        effs: ->
            @convert_binary_to_tf [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

        zeros: ->
            @convert_binary_to_tf [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

        sees: ->
            @convert_binary_to_tf [0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1]

        threes: ->
            @convert_binary_to_tf [1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0]

        bitwiseFunction: (a, b, operation)->
            operation(a[bit], b[bit]) for value,bit in a

        and_array: (a,b)->
            @bitwiseFunction a, b, (x,y) ->
                x and y

        or_array: (a,b)->
            @bitwiseFunction a, b, (x,y) ->
                x or y

        xor_array: (a,b)->
            @bitwiseFunction a, b, (x,y) ->
                (x and not y) or (y and not x)

        not_array: (a)->
            @bitwiseFunction a, [], (x) ->
                not x

    module.exports = Grader_ch4
).call this
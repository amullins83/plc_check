(->

    "use strict"
    Find = require "./find.coffee"
    RSLStartEnd = require "./RSLParser/RSLStartEnd.coffee"
    RSLInput = require "./RSLParser/RSLInput.coffee"
    RSLOutput = require "./RSLParser/RSLOutput.coffee"
    RSLOneShot = require "./RSLParser/RSLOneShot.coffee"
    RSLBranch = require "./RSLParser/RSLBranch.coffee"
    RSLLogical = require "./RSLParser/RSLLogical.coffee"
    RSLCounterTimer = require "./RSLParser/RSLCounterTimer.coffee"
    RSLComparisons = require "./RSLParser/RSLComparisons.coffee"
    
    
    class RSLParser
        constructor: ->
    
    
        @functionMap:
            "SOR,(\\d+)": RSLStartEnd.SOR
            , "EOR,(\\d+)": RSLStartEnd.EOR
            , "END,(\\d+)": RSLStartEnd.END
            , "XIC,(\\w+):(\\d+)\\/(\\w{1,2})": RSLInput.XIC
            , "XIO,(\\w+):(\\d+)\\/(\\w{1,2})": RSLInput.XIO
            , "OTE,(\\w+):(\\d+)\\/(\\d{1,2})": RSLOutput.OTE
            , "OTL,(\\w+):(\\d+)\\/(\\d{1,2})": RSLOutput.OTL
            , "OTU,(\\w+):(\\d+)\\/(\\d{1,2})": RSLOutput.OTU
            , "OSR,(\\w+):(\\d+)\\/(\\d{1,2})": RSLOneShot.OSR
            , "BST,(\\d+)": RSLBranch.BST
            , "NXB,(\\d+)": RSLBranch.NXB
            , "BND,(\\d+)": RSLBranch.BND
            , "AND,(\\w+):(\\d+),(\\w+):(\\d+),(\\w+):(\\d+)": RSLLogical.AND
            , "OR,(\\w+):(\\d+),(\\w+):(\\d+),(\\w+):(\\d+)":  RSLLogical.OR
            , "XOR,(\\w+):(\\d+),(\\w+):(\\d+),(\\w+):(\\d+)": RSLLogical.XOR
            , "NOT,(\\w+):(\\d+),(\\w+):(\\d+)": RSLLogical.NOT
            , "TON,T4:(\\d+),(\\d+)": RSLCounterTimer.TON
            , "TOF,T4:(\\d+),(\\d+)": RSLCounterTimer.TOF
            , "RTO,T4:(\\d+),(\\d+)": RSLCounterTimer.RTO
            , "RES,(\\w+):(\\d+)":    RSLCounterTimer.RES
            , "CTU,C5:(\\d+),(\\d+)": RSLCounterTimer.CTU
            , "CTD,C5:(\\d+),(\\d+)": RSLCounterTimer.CTD
            , "LES,(\\w+):(\\d+),(\\w+):(\\d+)": RSLComparisons.LES
            , "GRT,(\\w+):(\\d+),(\\w+):(\\d+)": RSLComparisons.GRT
            , "EQU,(\\w+):(\\d+),(\\w+):(\\d+)": RSLComparisons.EQU
            , "NEQ,(\\w+):(\\d+),(\\w+):(\\d+)": RSLComparisons.NEQ
            , "LEQ,(\\w+):(\\d+),(\\w+):(\\d+)": RSLComparisons.LEQ
            , "GEQ,(\\w+):(\\d+),(\\w+):(\\d+)": RSLComparisons.GEQ
            , "LIM,(\\w+):(\\d+),(\\w+):(\\d+),(\\w+):(\\d+)": RSLComparisons.LIM
    
        @execute: (instruction, dataTable)->
            for re, f of @functionMap
                matchValues = instruction.match new RegExp(re, "i") 
                if matchValues?
                    dataTable = f matchValues, dataTable
            return dataTable

        @runRung: (rungText, dataTable)->
            for instruction in rungText.split " "
                dataTable = @execute instruction, dataTable        
            return dataTable

        @runRoutine: (programText, dataTable)->
            dataTable.rungs = []
            programText = programText.replace /OR ,/, "OR," 
            rungs = programText.match /SOR,\d+ .*E(OR|ND),\d+/g
            if rungs?
                for rung in rungs
                    dataTable = @runRung rung, dataTable
                    break unless dataTable.programOpen
            return dataTable
    
    module.exports = RSLParser
).call this
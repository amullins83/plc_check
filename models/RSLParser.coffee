(->

    "use strict"
    Find = require "./RSLParser/find.coffee"
    RSLStartEnd = require "./RSLParser/RSLStartEnd.coffee"
    RSLInput = require "./RSLParser/RSLInput.coffee"
    RSLOutput = require "./RSLParser/RSLOutput.coffee"
    RSLOneShot = require "./RSLParser/RSLOneShot.coffee"
    RSLBranch = require "./RSLParser/RSLBranch.coffee"
    RSLLogical = require "./RSLParser/RSLLogical.coffee"
    RSLCounterTimer = require "./RSLParser/RSLCounterTimer.coffee"
    
    
    class RSLParser
        constructor: ->
    
    
        @functionMap:
            "SOR,(\\d+)": RSLStartEnd.SOR
            , "EOR,(\\d+)": RSLStartEnd.EOR
            , "END,(\\d+)": RSLStartEnd.END
            , "XIC,(\\w+):(\\d+)\\/(\\d{1,2})": RSLInput.XIC
            , "XIO,(\\w+):(\\d+)\\/(\\d{1,2})": RSLInput.XIO
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
    
    
        @execute: (instruction, dataTable)->
            for re, f of @functionMap
                matchValues = instruction.match new RegExp(re) 
                if matchValues?
                    dataTable = f matchValues, dataTable
            return dataTable
    
    module.exports = RSLParser
).call this
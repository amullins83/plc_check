class RSLStartEnd
    constructor: ->

    @SOR: (matchValues, dataTable)->
        [matchText, rungNumber] = matchValues
        dataTable.rungs = dataTable.rungs || []
        dataTable.rungs.push rungNumber
        dataTable.activeRung = rungNumber
        dataTable.rungOpen = true
        dataTable.programOpen = true
        return dataTable
    
    @ending: (lastAction, errorMessage = "EOR does not match SOR")->
        (matchValues, dataTable)->
            [matchText, rungNumber] = matchValues
            if rungNumber == dataTable.activeRung
                dataTable.rungOpen = false
                if typeof lastAction  == "Function"
                    lastAction()
                return dataTable
            else
                throw errorMessage
    
    @EOR: @ending()
    
    @END: @ending ->
        dataTable.programOpen = false
    , "END does not match SOR"

module.exports = RSLStartEnd
class RSLOutput
    constructor: ->

    @bitwiseOutput: (set, latchAction = -> )->
        (matchValues, dataTable)->
            [matchText, file, rank, bit] = matchValues
            dataTable[file] = dataTable[file] || {}
            dataTable[file][rank] = dataTable[file][rank] || {}
            dataTable[file][rank][bit] = set
            dataTable = latchAction dataTable
    
    @OTE:  @bitwiseOutput true
    
    @OTL:  @bitwiseOutput true, (dataTable)->
        dataTable["latch"] = dataTable["latch"] || []
        if dataTable["latch"].indexOf {file: file, rank: rank, bit: bit} == -1
            dataTable["latch"].push {file: file, rank: rank, bit: bit}
        return dataTable
    
    @OTU: @bitwiseOutput false, (dataTable)->
        if dataTable["latch"]?
            removeIndex = dataTable["latch"].indexOf {file: file, rank: rank, bit: bit}
        unless removeIndex == -1
            dataTable.splice removeIndex, 1
        return dataTable
class RSLOneShot
    constructor: ->

    @OSR: (matchValues, dataTable)->
        [matchText, file, rank, bit] = matchValues
        if dataTable[file][rank][bit]
            return false
        else
            dataTable[file][rank][bit] = true
            dataTable["oneShots"] = dataTable["oneShots"] || []
            findObject = {file:file, rank:rank, bit:bit}
            foundOneShots = dataTable["oneShots"].find findObject
            if foundOneShots.length == 0
                dataTable["oneShots"].push {file: file, rank: rank, bit: bit, active: true}
            else
                dataTable["oneShots"].update findObject, {file: file, rank: rank, bit: bit, active:true}
            return dataTable
class RSLLogical
    constructor: ->

    @Logical: (bitwiseFunction)->
        (matchValues, dataTable)->
            [matchText, sourceAfile, sourceArank, sourceBfile, sourceBrank, destFile, destRank] = matchValues
            dataTable[destFile] = dataTable[destFile] || {}
            dataTable[destFile][destRank] = dataTable[destFile][destRank] || {}
            for i in [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
                dataTable[sourceAfile][sourceArank][i] = dataTable[sourceAfile][sourceArank][i] || 0
                dataTable[sourceBfile][sourceBrank][i] = dataTable[sourceBfile][sourceBrank][i] || 0
                dataTable[destFile][destRank][i] = bitwiseFunction dataTable[sourceAfile][sourceArank][i], dataTable[sourceBfile][sourceBrank][i]
            return dataTable
    
    @AND: @Logical (a,b)->
        a and b
    
    @OR: @Logical (a,b)->
        a or b
    
    @XOR: @Logical (a,b)->
        a ^ b
    
    @NOT: @Logical (a,b)->
        not a
    
class RSLInput
    constructor: ->

    @bitwiseInput: (bitwiseFunction)->
        (matchValues, dataTable)->
            [matchText, file, rank, bit] = matchValues
            if bitwiseFunction(dataTable[file][rank][bit])
                return dataTable
            else
                return false
    
    @XIC: @bitwiseInput (bit)->
        return bit == true or bit == 1
    
    @XIO: @bitwiseInput (bit)->
        return bit == false or bit == 0
class RSLCounterTimer
    constructor: ->

    @CounterTimer: class CounterTimer
        constructor: (@number, @preset)->
            @acc = 0
            @en = true
            @dn = @done()
        
        tickUp: ->
            @acc++
            @dn = @done()
        
        tickDown: ->
            @acc--
            @dn = @done()
        
        done: ->
            @acc >= @preset
    
    @Counter: class Counter extends @CounterTimer
        CU: ->
            @tickUp()
            @cu = true
    
        CD: ->
            @tickDown()
            @cu = true
    
        OV: ->
    
        UV: ->
        
    
    @Timer: class Timer extends @CounterTimer
        tick: ->
            unless @done()
                @tickUp()
                @tt = true
            else
                @tt = false
        
    @counterTimerInstruction: (file, action)->
        (matchValues, dataTable)->
            [number, preset] = matchValues
            dataTable[file] = dataTable[file] || {}
            dataTable[file][number] = dataTable[file][number] || new @CounterTimer(number, preset)
            unit = dataTable[file][number]
            dataTable = action(unit)
        
    @timerInstruction: (timerAction)->
        @counterTimerInstruction "T4", timerAction
        
    @TON: @timerInstruction (timer)->
        
        
    @TOF: @timerInstruction (timer)->
        
    @RTO: @timerInstruction (timer)->
    
    @RES: (matchValues, dataTable)->
        [matchText, file, rank] = matchValues
        dataTable[file][rank].acc = 0
        
    @counterInstruction: (counterAction)->
        @counterTimerInstruction "C5", counterAction
        
    @CTU: @counterInstruction (counter)->
        
    @CTD: @counterInstruction (counter)->
        
class RSLBranch
    constructor: ->

    @Branch: class Branch
        constructor: (@branchNumber)->
            @topLine    = true
            @bottomLine = true
            @onTopLine  = true
            @open       = true
    
    @branchInstruction: (branchAction)->
        (matchValues, dataTable)->
            [matchText, branchNumber] = matchValues
            dataTable = branchAction dataTable
    
    @BST: @branchInstruction (dataTable)->
        dataTable.branches = dataTable.branches || []
        dataTable.branches[branchNumber - 1] = new Branch branchNumber
        return dataTable
    
    @branchClosing: (closingType)->
        @branchInstruction (dataTable)->
            activeBranch = dataTable.branches[branchNumber - 1]
            if closingType == "NXB"
                correctLine = activeBranch.onTopLine
                thingToClose = "onTopLine"
            else
                correctLine = not activeBranch.onTopLine
                thingToClose = "open"
    
            if correctLine
                if activeBranch.open
                    activeBranch[thingToClose] = false
                    dataTable.branches[branchNumber - 1] = activeBranch
                    return dataTable
                else
                    throw "Encountered #{closingType} for closed branch"
            else
                throw "Unexpected #{closingType}"
    
    @NXB: @branchClosing "NXB"
    
    @BND: @branchClosing "BND"
    

    



 


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

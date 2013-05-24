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
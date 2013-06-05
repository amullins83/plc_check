(->

    "use strict"
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
                [matchText, branchNumberString] = matchValues
                branchNumber = parseInt branchNumberString, 10
                dataTable = branchAction branchNumber, dataTable
        
        @BST: @branchInstruction (branchNumber, dataTable)->
            dataTable.branches = dataTable.branches || []
            dataTable.branches[branchNumber - 1] = new Branch branchNumber
            dataTable.activeBranch = branchNumber
            return dataTable
        
        @branchClosing: (closingType)->
            @branchInstruction (branchNumber, dataTable)->
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
                        if closingType == "BND"
                            dataTable.activeBranch = branchNumber - 1
                        return dataTable
                    else
                        throw "Unexpected #{closingType}"
                else
                    throw "Unexpected #{closingType}"
        
        @NXB: @branchClosing "NXB"
        
        @BND: @branchClosing "BND"

        module.exports = RSLBranch
).call this
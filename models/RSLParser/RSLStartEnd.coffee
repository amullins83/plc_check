(->
    "use strict"

    class RSLStartEnd
        constructor: ->
    
        @SOR: (matchValues, dataTable)->
            [matchText, rungNumberString] = matchValues
            rungNumber = parseInt rungNumberString, 10
            dataTable.rungs = dataTable.rungs || []
            dataTable.rungs.push rungNumber
            dataTable.activeRung = rungNumber
            dataTable.rungOpen = true
            dataTable.programOpen = true
            dataTable.activeBranch = 0
            return dataTable
        
        @ending: (lastAction, errorMessage = "EOR does not match SOR")->
            (matchValues, dataTable)->
                [matchText, rungNumberString] = matchValues
                rungNumber = parseInt rungNumberString, 10
                if rungNumber == dataTable.activeRung
                    dataTable.rungOpen = false
                    if typeof lastAction  != "undefined"
                        dataTable = lastAction(dataTable)
                    return dataTable
                else
                    throw errorMessage
        
        @EOR: @ending()
        
        @END: @ending (dataTable)->
            dataTable.programOpen = false
            return dataTable
        , "END does not match SOR"
    
    module.exports = RSLStartEnd
).call this